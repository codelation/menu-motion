describe "MenuMotion::MenuItem" do

  it "should be defined" do
    MenuMotion::MenuItem.is_a?(Class).should.equal true
  end

  it "should be an NSMenuItem" do
    menu_item = MenuMotion::MenuItem.new
    menu_item.is_a?(NSMenuItem).should.equal true
  end

  it "should accept a set of permitted attributes on initialization" do
    dummy = Dummy.new

    menu_item = MenuMotion::MenuItem.new({
      title: "Hello World",
      target: dummy,
      action: "dummy_action",
      shortcut: "cmd+h",
      object: dummy
    })

    menu_item.title.should.equal "Hello World"
    menu_item.item_target.should.equal dummy
    menu_item.item_action.should.equal "dummy_action"
    menu_item.keyEquivalent.should.equal "h"
    menu_item.keyEquivalentModifierMask.should.equal NSCommandKeyMask
    menu_item.object.should.equal dummy
    menu_item.representedObject.should.equal dummy
  end

  it "#update should set permitted attributes on the menu item" do
    dummy = Dummy.new

    menu_item = MenuMotion::MenuItem.new({
      title: "Hello World",
      shortcut: "h"
    })
    menu_item.keyEquivalent.should.equal "h"

    menu_item.update({
      title: "What's up?",
      target: dummy,
      action: "dummy_action",
      shortcut: "cmd-control-w"
    })

    menu_item.title.should.equal "What's up?"
    menu_item.item_target.should.equal dummy
    menu_item.item_action.should.equal "dummy_action"
    menu_item.keyEquivalent.should.equal "w"
    menu_item.keyEquivalentModifierMask.should.equal(NSCommandKeyMask | NSControlKeyMask)
  end

  it "#perform_action should perform the action on the given target" do
    dummy = Dummy.new

    menu_item = MenuMotion::MenuItem.new({
      title: "Hello",
      target: dummy,
      action: "dummy_action"
    })

    menu_item.perform_action
    dummy.action_completed.should.equal true
  end

  it "#perform_action should send the menu item to the action if it ends with `:`" do
    dummy = Dummy.new

    menu_item = MenuMotion::MenuItem.new({
      title: "Hello",
      target: dummy,
      action: "dummy_action_with_sender:"
    })

    menu_item.perform_action
    dummy.sender.should.equal menu_item
  end

end

class Dummy
  attr_accessor :action_completed, :sender

  def dummy_action
    self.action_completed = true
  end

  def dummy_action_with_sender(sender)
    self.sender = sender
  end
end
