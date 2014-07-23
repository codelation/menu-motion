module MenuMotion

  class MenuItem < NSMenuItem

    attr_accessor :item_action, :item_target,
                  :root_menu, :tag, :validate

    alias_method :object,  :representedObject
    alias_method :object=, :setRepresentedObject

    def checked
      self.state == NSOnState
    end
    alias_method :checked?, :checked

    def checked=(value)
      self.state = (value ? NSOnState : NSOffState)
    end

    def image=(i)
      i = NSImage.imageNamed(i) unless i.is_a?(NSImage)
      self.setImage(i)
    end

    def initialize(params = {})
      super()
      update(params)
      self
    end

    def perform_action
      if self.valid? && self.valid_target_and_action?
        if self.item_action.to_s.end_with?(":")
          self.item_target.performSelector(self.item_action, withObject: self)
        else
          self.item_target.performSelector(self.item_action)
        end
      end
    end

    def update(params)
      assign_attributes(params)

      self.item_action = params[:action] if params.has_key?(:action)
      self.item_target = params[:target] if params.has_key?(:target)

      # Set NSApp as the default target if no other target is given
      if self.item_action && self.item_target.nil?
        self.item_target = NSApp
      end

      # Setup submenu and keyboard shortcut
      set_submenu_from_params(params)
      set_keyboard_shortcut(params[:shortcut]) if params.has_key?(:shortcut)

      self
    end

    def valid?
      if self.submenu || self.valid_target_and_action?
        if self.validate.nil?
          true
        else
          self.validate.call(self)
        end
      else
        false
      end
    end

    def valid_target_and_action?
      self.item_target && self.item_action && self.item_target.respond_to?(self.item_action.gsub(":", ""))
    end

  private

    def set_keyboard_shortcut(shortcut)
      if shortcut
        keys = shortcut.gsub("-", "+").split("+")
        key = keys.pop
        modifier_mask = 0
        modifier_keys = keys

        modifier_keys.each do |modifier_key|
          case modifier_key
          when "alt", "alternate", "opt", "option"
            modifier_mask |= NSAlternateKeyMask
          when "cmd", "command"
            modifier_mask |= NSCommandKeyMask
          when "ctl", "ctrl", "control"
            modifier_mask |= NSControlKeyMask
          when "shift"
            modifier_mask |= NSShiftKeyMask
          end
        end

        self.setKeyEquivalent(key)
        self.setKeyEquivalentModifierMask(modifier_mask)
      else
        self.setKeyEquivalent(nil)
        self.setKeyEquivalentModifierMask(nil)
      end
    end

    def set_submenu_from_params(params)
      if params[:sections]
        submenu = MenuMotion::Menu.new({
          title: self.title,
          sections: params[:sections]
        }, self.root_menu)
        self.setSubmenu(submenu)
      elsif params[:rows]
        submenu = MenuMotion::Menu.new({
          title: self.title,
          rows: params[:rows]
        }, self.root_menu)
        self.setSubmenu(submenu)
      end
    end

  private

    def assign_attributes(params)
      [:image, :view, :checked, :object, :root_menu, :title, :validate].each do |key|
        self.send("#{key}=", params[key]) if params.has_key?(key)
      end
    end

  end

end

