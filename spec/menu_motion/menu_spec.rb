describe "MenuMotion::Menu" do

  it "should be defined" do
    MenuMotion::Menu.is_a?(Class).should.equal true
  end

  it "should be an NSMenu" do
    menu = MenuMotion::Menu.new
    menu.is_a?(NSMenu).should.equal true
  end

  it "Defining rows adds menu items" do
    menu = MenuMotion::Menu.new({
      rows: [{
        title: "Row 1"
      }, {
        title: "Row 2"
      }, {
        title: "Row 3"
      }]
    })

    menu.itemArray.length.should.equal 3
    menu.itemAtIndex(0).title.should.equal "Row 1"
    menu.itemAtIndex(1).title.should.equal "Row 2"
    menu.itemAtIndex(2).title.should.equal "Row 3"
  end

  it "Can set a target and action on a row" do
    class Dummy
      attr_accessor :action_completed

      def dummy_action
        self.action_completed = true
      end
    end

    dummy = Dummy.new

    menu = MenuMotion::Menu.new({
      rows: [{
        title: "Row 1",
        target: dummy,
        action: "dummy_action"
      }]
    })

    menu.performActionForItemAtIndex(0)
    dummy.action_completed.should.equal true
  end

  it "Using sections adds dividers between sets of rows" do
    menu = MenuMotion::Menu.new({
      sections: [{
        rows: [{
          title: "Section 1 Row 1"
        }, {
          title: "Section 1 Row 2"
        }]
      }, {
        rows: [{
          title: "Section 2 Row 1"
        }]
      }, {
        rows: [{
          title: "Section 3 Row 1"
        }, {
          title: "Section 3 Row 2"
        }, {
          title: "Section 3 Row 3"
        }]
      }]
    })

    menu.itemArray.length.should.equal 8
    menu.itemAtIndex(0).title.should.equal "Section 1 Row 1"
    menu.itemAtIndex(1).title.should.equal "Section 1 Row 2"
    menu.itemAtIndex(2).isSeparatorItem.should.equal true
    menu.itemAtIndex(3).title.should.equal "Section 2 Row 1"
    menu.itemAtIndex(4).isSeparatorItem.should.equal true
    menu.itemAtIndex(5).title.should.equal "Section 3 Row 1"
    menu.itemAtIndex(6).title.should.equal "Section 3 Row 2"
    menu.itemAtIndex(7).title.should.equal "Section 3 Row 3"
  end

  it "Including rows in a row item creates a submenu" do
    menu = MenuMotion::Menu.new({
      rows: [{
        title: "Menu item",
        rows: [{
          title: "Submenu item 1"
        }, {
          title: "Submenu item 2"
        }]
      }]
    })

    menu.itemArray.length.should.equal 1

    menu_item = menu.itemAtIndex(0)
    menu_item.submenu.is_a?(NSMenu).should.equal true

    menu_item.submenu.itemArray.length.should.equal 2
    menu_item.submenu.itemAtIndex(0).title.should.equal "Submenu item 1"
    menu_item.submenu.itemAtIndex(1).title.should.equal "Submenu item 2"
  end

  it "Including sections in a row item creates a submenu" do
    menu = MenuMotion::Menu.new({
      rows: [{
        title: "Menu item",
        sections: [{
          rows: [{
            title: "Section 1 Row 1"
          }, {
            title: "Section 1 Row 2"
          }]
        }, {
          rows: [{
            title: "Section 2 Row 1"
          }]
        }]
      }]
    })

    menu.itemArray.length.should.equal 1

    menu_item = menu.itemAtIndex(0)
    menu_item.submenu.is_a?(NSMenu).should.equal true

    menu_item.submenu.itemArray.length.should.equal 4
    menu_item.submenu.itemAtIndex(0).title.should.equal "Section 1 Row 1"
    menu_item.submenu.itemAtIndex(1).title.should.equal "Section 1 Row 2"
    menu_item.submenu.itemAtIndex(2).isSeparatorItem.should.equal true
    menu_item.submenu.itemAtIndex(3).title.should.equal "Section 2 Row 1"
  end

  it "#item_with_key returns menu items by the lookup key" do
    menu = MenuMotion::Menu.new({
      rows: [{
        title: "Menu item",
        key: :main_item,
        sections: [{
          rows: [{
            title: "Section 1 Row 1",
            key: :section1_row1
          }, {
            title: "Section 1 Row 2",
            key: :section1_row2
          }]
        }, {
          rows: [{
            title: "Section 2 Row 1",
            key: :section2_row1
          }]
        }]
      }]
    })

    item = menu.item_with_key(:main_item)
    item.title.should.equal "Menu item"

    item = menu.item_with_key(:section1_row1)
    item.title.should.equal "Section 1 Row 1"

    item = menu.item_with_key(:section1_row2)
    item.title.should.equal "Section 1 Row 2"

    item = menu.item_with_key(:section2_row1)
    item.title.should.equal "Section 2 Row 1"
  end

  it "Updates the title of the menu item with the given key" do
    menu = MenuMotion::Menu.new({
      rows: [{
        title: "Menu item",
        key: :main_item,
        sections: [{
          rows: [{
            title: "Section 1 Row 1",
            key: :section1_row1
          }, {
            title: "Section 1 Row 2",
            key: :section1_row2
          }]
        }, {
          rows: [{
            title: "Section 2 Row 1",
            key: :section2_row1
          }]
        }]
      }]
    })

    menu.update(:section1_row2, {
      title: "New Title"
    })

    menu.itemAtIndex(0).submenu.itemAtIndex(1).title.should.equal "New Title"
  end

  it "Updates the target and action of the menu item with the given key" do
    class Dummy
      attr_accessor :action_completed

      def dummy_action
        self.action_completed = true
      end
    end

    dummy = Dummy.new

    menu = MenuMotion::Menu.new({
      rows: [{
        title: "Menu item",
        key: :main_item,
        sections: [{
          rows: [{
            title: "Section 1 Row 1",
            key: :section1_row1
          }, {
            title: "Section 1 Row 2",
            key: :section1_row2
          }]
        }, {
          rows: [{
            title: "Section 2 Row 1",
            key: :section2_row1
          }]
        }]
      }]
    })

    menu.update(:main_item, {
      target: dummy,
      action: "dummy_action"
    })

    menu.performActionForItemAtIndex(0)
    dummy.action_completed.should.equal true
  end

end
