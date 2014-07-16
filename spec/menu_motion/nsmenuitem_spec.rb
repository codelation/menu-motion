describe "NSMenuItem Core Extensions" do

  before do
    @menu_item = NSMenuItem.new
  end

  it 'should set checkmarks' do
    @menu_item.state.should.equal NSOffState
    @menu_item.checked = true
    @menu_item.state.should.equal NSOnState
    @menu_item.checked = false
    @menu_item.state.should.equal NSOffState
  end

  it 'should get the checked state as a boolean' do
    @menu_item.checked?.should.equal false
    @menu_item.checked = true
    @menu_item.checked?.should.equal true
  end

end
