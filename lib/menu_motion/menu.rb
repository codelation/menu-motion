module MenuMotion

  class Menu < NSMenu

    attr_accessor :menu_items
    attr_accessor :root_menu

    def add_rows_to_menu(menu, rows)
      rows.each do |row|
        menu_item = NSMenuItem.alloc.initWithTitle(row[:title], action: row[:action], keyEquivalent:"")
        menu_item.target = row[:target]

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

        if row[:key]
          if self.root_menu
            self.root_menu.menu_items ||= {}
            self.root_menu.menu_items[row[:key].to_sym] = WeakRef.new(menu_item)
          else
            self.menu_items ||= {}
            self.menu_items[row[:key].to_sym] = WeakRef.new(menu_item)
          end
        end

        menu.addItem(menu_item)
      end
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
      super()

      self.root_menu = root_menu
      self.build_menu_from_params(self, params)

      self
    end

    def item_with_key(key)
      @menu_items ||= {}
      @menu_items[key.to_sym]
    end

    def update(key, params)
      menu_item = self.item_with_key(key)

      menu_item.title  = params[:title]  if params[:title]
      menu_item.target = params[:target] if params[:target]
      menu_item.action = params[:action] if params[:action]

      self
    end

  end

end

