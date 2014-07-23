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
    image = NSImage.imageNamed('stopwatch')
    view = NSView.new

    menu_item = MenuMotion::MenuItem.new({
      title: "Hello World",
      target: dummy,
      action: "dummy_action",
      shortcut: "cmd+h",
      object: dummy,
      checked: true,
      image: image,
      view: view
    })

    menu_item.title.should.equal "Hello World"
    menu_item.item_target.should.equal dummy
    menu_item.item_action.should.equal "dummy_action"
    menu_item.keyEquivalent.should.equal "h"
    menu_item.keyEquivalentModifierMask.should.equal NSCommandKeyMask
    menu_item.object.should.equal dummy
    menu_item.representedObject.should.equal dummy
    menu_item.state.should.equal NSOnState
    menu_item.image.should.equal image
    menu_item.view.should.equal view
  end

  it "#update should set permitted attributes on the menu item" do
    dummy = Dummy.new
    view1 = NSView.new
    view2 = NSView.new

    menu_item = MenuMotion::MenuItem.new({
      title: "Hello World",
      shortcut: "h",
      checked: true,
      view: view1
    })
    menu_item.keyEquivalent.should.equal "h"
    menu_item.state.should.equal NSOnState
    menu_item.view.should.equal view1

    menu_item.update({
      title: "What's up?",
      target: dummy,
      action: "dummy_action",
      shortcut: "cmd-control-w",
      checked: false,
      view: view2
    })

    menu_item.title.should.equal "What's up?"
    menu_item.item_target.should.equal dummy
    menu_item.item_action.should.equal "dummy_action"
    menu_item.keyEquivalent.should.equal "w"
    menu_item.keyEquivalentModifierMask.should.equal(NSCommandKeyMask | NSControlKeyMask)
    menu_item.state.should.equal NSOffState
    menu_item.view.should.equal view2
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

  it "#image should set the NSMenuItem#image with a string" do
    menu_item = MenuMotion::MenuItem.new

    menu_item.image.should.equal nil
    menu_item.image = 'stopwatch'
    menu_item.image.should.not.equal nil
    menu_item.image.class.should.equal NSImage
  end

  it "#image should set the NSMenuItem#image with a NSImage" do
    menu_item = MenuMotion::MenuItem.new
    image = NSImage.imageNamed('stopwatch')

    menu_item.image.should.equal nil
    menu_item.image = image
    menu_item.image.should.equal image
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
