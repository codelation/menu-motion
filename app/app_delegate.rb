class AppDelegate

  def applicationDidFinishLaunching(notification)
    menu = MenuMotion::Menu.new({
      sections: [{
        rows: [{
          icon: "icon.png",
          title: "First Item",
          sections: [{
            rows: [{
              title: "First Subitem",
              rows: [{
                title: "First Action",
                target: self,
                action: "first_action"
              }, {
                title: "Second Action",
                target: self,
                action: "action_with_sender:"
              }]
            }]
          }, {
            rows: [{
              title: "Some Action",
              target: self,
              action: "some_action"
            }]
          }]
        }]
      }, {
        rows: [{
          title: "About MenuMotion",
          target: self,
          action: "about"
        }, {
          title: "Quit",
          target: self,
          action: "quit"
        }]
      }]
    })
    status_item.setMenu(menu)
  end

  def first_action
    ap "First action!"
  end

  def action_with_sender(sender)
    ap sender
  end

  def status_item
    @status_item ||= begin
      status_item = NSStatusBar.systemStatusBar.statusItemWithLength(NSSquareStatusItemLength).init
      status_item.setHighlightMode(true)

      status_image = NSImage.imageNamed("stopwatch.pdf")
      status_item.setImage(status_image)

      alt_status_image = NSImage.imageNamed("stopwatch-alt.pdf")
      status_item.setAlternateImage(alt_status_image)

      status_item
    end
  end
end
