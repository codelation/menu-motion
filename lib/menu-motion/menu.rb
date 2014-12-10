module MenuMotion

  class Menu < NSMenu

    attr_accessor :menu_items, :root_menu

    def add_rows_to_menu(menu, rows)
      rows.each do |row|
        row[:root_menu] = self.root_menu || self
        menu_item = MenuMotion::MenuItem.new(row)
        menu_item.target = self
        menu_item.action = "perform_action:"

        if tag = row[:tag]
          tag = tag.to_sym
          menu_item.tag = tag

          if self.root_menu
            self.root_menu.menu_items ||= {}
            self.root_menu.menu_items[tag] = menu_item
          else
            self.menu_items ||= {}
            self.menu_items[tag] = menu_item
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
      if params[:title]
        initWithTitle(params[:title])
      else
        super()
      end

      self.root_menu = root_menu
      self.build_menu_from_params(self, params)

      self
    end

    def item_with_tag(tag)
      @menu_items ||= {}
      @menu_items[tag.to_sym]
    end

    def perform_action(menu_item)
      menu_item.perform_action
    end

    def update_item_with_tag(tag, params)
      menu_item = self.item_with_tag(tag)
      menu_item.update(params)
    end

    def validateMenuItem(menu_item)
      menu_item.valid?
    end

  end

end
