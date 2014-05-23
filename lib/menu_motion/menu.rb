module MenuMotion

  class Menu < NSMenu

    attr_accessor :menu_items
    attr_accessor :root_menu
    attr_accessor :tag

    def add_rows_to_menu(menu, rows)
      rows.each do |row|
        menu_item = MenuMotion::MenuItem.new(row[:title], row[:target], row[:action], row[:validate])
        menu_item.target = self
        menu_item.action = '_menu_item_action:'

        # Add sections and/or rows to a submenu
        if row[:sections]
          submenu = MenuMotion::Menu.new({
                                           sections: row[:sections]
                                         }, self.root_menu || self)
          menu_item.setSubmenu(submenu)
        elsif row[:rows]
          submenu = MenuMotion::Menu.new({
                                           rows: row[:rows]
                                         }, self.root_menu || self)
          menu_item.setSubmenu(submenu)
        end

        if (tag=row[:tag])
          tag = tag.to_sym

          if self.root_menu
            self.root_menu.menu_items ||= {}
            self.root_menu.menu_items[tag] = WeakRef.new(menu_item)
          else
            self.menu_items ||= {}
            self.menu_items[tag] = WeakRef.new(menu_item)
          end

          menu_item.tag = tag
        end

        if (ke=row[:shortcut])
          parts = ke.split('+')
          k = parts.pop

          raise MMException.new("Missing key char for menu item #{menu_item.title} shortcut: #{ke}") unless (k)
          raise MMException.new("Unknown key char for menu item #{menu_item.title} shortcut: #{ke}") unless (k.length == 1)

          mod_mask = parts.inject(0) do |mask,mod|
            case mod
            when 'shift'
              mask |= NSShiftKeyMask
            when 'alt', 'alternate'
              mask |= NSAlternateKeyMask
            when 'command', 'cmd'
              mask |= NSCommandKeyMask
            when 'control', 'ctl', 'ctrl'
              mask |= NSControlKeyMask
            else
              raise MMException.new("Unknown key modifier for menu item #{menu_item.title} shortcut: #{mod.to_s}. Want any of: shift, alt, alternate, command, cmd, control, ctrl, ctl")
            end

            mask
          end

          menu_item.setKeyEquivalent(k)
          menu_item.setKeyEquivalentModifierMask(mod_mask)
        end

        menu.addItem(menu_item)
      end
    end

    def validateMenuItem(menu_item)
      menu_item.validate
    end

    def add_sections_to_menu(menu, sections)
      sections.each_with_index do |section, index|
        if section[:rows]
          if index > 0
            # Add the separator before the new section,
            # skipping the first section
            menu.addItem(NSMenuItem.separatorItem)
          end
          add_rows_to_menu(menu, section[:rows])
        end
      end
    end

    def build_menu_from_params(menu, params)
      if params[:sections]
        add_sections_to_menu(menu, params[:sections])
      elsif params[:rows]
        add_rows_to_menu(menu, params[:rows])
      end
    end

    def initialize(params = {}, root_menu = nil)
      initWithTitle(params[:title] || 'Add A Title!')

      self.root_menu = root_menu
      self.build_menu_from_params(self, params)

      self
    end

    def item_with_tag(tag)
      @menu_items ||= {}
      @menu_items[tag.to_sym]
    end

    def reconfigure(tag, params)
      menu_item = self.item_with_tag(tag)

      [
       :title,
       :target,
       :action,
       :validate,
       :tag,
       :shortcut,
       :enabled
      ].each do |f|
        menu_item.send("#{f}=",params[f]) if (params.has_key?(f))
      end

      self
    end

    def _menu_item_action(menu_item)
      menu_item.act
    end

  end

  class MenuItem < NSMenuItem

    attr_accessor :tag

    def initialize(title, target, action, validate)
      initWithTitle(title, action: nil, keyEquivalent: '')

      @mi_validate = validate
      @mi_target = target
      @mi_action = action
      self
    end

    def act
      target = @mi_target || NSApp

      if (@mi_action)
        if (target.class.instance_method(@mi_action).arity == 0)
          target.send(@mi_action) 
        else
          target.send(@mi_action,self)
        end
      end
    end

    def validate
      if (@mi_validate.kind_of?(Proc))
        return true unless (@mi_validate)

        @mi_validate.call(self)
      else
        return true unless (@mi_validate && @mi_target)

        @mi_target.send(@mi_validate,self)
      end
    end

  end

  class MMException < ::Exception
  end
end

