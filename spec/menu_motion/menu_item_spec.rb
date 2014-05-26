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
      action: "dummy_action"
    })

    menu_item.title.should.equal "Hello World"
    menu_item.item_target.should.equal dummy
    menu_item.item_action.should.equal "dummy_action"
  end

  it "#update should set permitted attributes on the menu item" do
    dummy = Dummy.new

    menu_item = MenuMotion::MenuItem.new({
      title: "Hello World"
    })

    menu_item.update({
      title: "What's up?",
      target: dummy,
      action: "dummy_action"
    })

    menu_item.title.should.equal "What's up?"
    menu_item.item_target.should.equal dummy
    menu_item.item_action.should.equal "dummy_action"
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