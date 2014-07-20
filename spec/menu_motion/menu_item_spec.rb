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
      object: dummy,
      checked: true,
      enabled: false
    })

    menu_item.title.should.equal "Hello World"
    menu_item.item_target.should.equal dummy
    menu_item.item_action.should.equal "dummy_action"
    menu_item.keyEquivalent.should.equal "h"
    menu_item.keyEquivalentModifierMask.should.equal NSCommandKeyMask
    menu_item.object.should.equal dummy
    menu_item.representedObject.should.equal dummy
    menu_item.state.should.equal NSOnState
    menu_item.isEnabled.should.equal false
  end

  it "#update should set permitted attributes on the menu item" do
    dummy = Dummy.new

    menu_item = MenuMotion::MenuItem.new({
      title: "Hello World",
      shortcut: "h",
      checked: true,
      enabled: false
    })
    menu_item.keyEquivalent.should.equal "h"
    menu_item.state.should.equal NSOnState
    menu_item.isEnabled.should.equal false

    menu_item.update({
      title: "What's up?",
      target: dummy,
      action: "dummy_action",
      shortcut: "cmd-control-w",
      checked: false,
      enabled: true
    })

    menu_item.title.should.equal "What's up?"
    menu_item.item_target.should.equal dummy
    menu_item.item_action.should.equal "dummy_action"
    menu_item.keyEquivalent.should.equal "w"
    menu_item.keyEquivalentModifierMask.should.equal(NSCommandKeyMask | NSControlKeyMask)
    menu_item.state.should.equal NSOffState
    menu_item.isEnabled.should.equal true
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

  it "#perform_action should perform the action when sent a symbol" do
    dummy = Dummy.new

    menu_item = MenuMotion::MenuItem.new({
      title: "Hello",
      target: dummy,
      action: :dummy_action
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

  it "#checked should set the NSMenuItem#state" do
    menu_item = MenuMotion::MenuItem.new
    menu_item.state.should.equal NSOffState
    menu_item.checked = true
    menu_item.state.should.equal NSOnState
    menu_item.checked = false
    menu_item.state.should.equal NSOffState
  end

  it "#checked should get the NSMenuItem#state" do
    menu_item = MenuMotion::MenuItem.new
    menu_item.checked.should.equal false
    menu_item.state = NSOnState
    menu_item.checked.should.equal true
    menu_item.state = NSOffState
    menu_item.checked.should.equal false
  end

  it "#checked? should also get the NSMenuItem#state" do
    menu_item = MenuMotion::MenuItem.new
    menu_item.checked?.should.equal false
    menu_item.state = NSOnState
    menu_item.checked?.should.equal true
    menu_item.state = NSOffState
    menu_item.checked?.should.equal false
  end

  it "#enabled should set NSMenuItem#isEnabled" do
    menu_item = MenuMotion::MenuItem.new
    menu_item.isEnabled.should.equal true
    menu_item.enabled = false
    menu_item.isEnabled.should.equal false
    menu_item.enabled = true
    menu_item.isEnabled.should.equal true
  end

  it "#enabled should get NSMenuItem#isEnabled" do
    menu_item = MenuMotion::MenuItem.new
    menu_item.enabled.should.equal true
    menu_item.setEnabled false
    menu_item.enabled.should.equal false
    menu_item.setEnabled true
    menu_item.enabled.should.equal true
  end

  it "#enabled? should get NSMenuItem#isEnabled" do
    menu_item = MenuMotion::MenuItem.new
    menu_item.enabled?.should.equal true
    menu_item.setEnabled false
    menu_item.enabled?.should.equal false
    menu_item.setEnabled true
    menu_item.enabled?.should.equal true
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
