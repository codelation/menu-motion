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
                action: "first_action",
                shortcut: "command+f"
              }, {
                title: "Second Action",
                target: self,
                action: "action_with_sender:",
                shortcut: "cmd+option+s"
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
          title: "Image MenuItem",
          image: "stopwatch"
        }]
      }, {
        rows: [{
          title: "About MenuMotion",
          action: "orderFrontStandardAboutPanel:"
        }, {
          title: "Quit",
          action: "terminate:"
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
      # Workaround for http://hipbyte.myjetbrains.com/youtrack/issue/RM-648
      # -2 means NSSquareStatusItemLength
      status_item = NSStatusBar.systemStatusBar.statusItemWithLength(-2).init
      status_item.setHighlightMode(true)

      status_image = NSImage.imageNamed("stopwatch.pdf")
      status_image.setTemplate(true)
      status_item.setImage(status_image)

      alt_status_image = NSImage.imageNamed("stopwatch-alt.pdf")
      alt_status_image.setTemplate(true)
      status_item.setAlternateImage(alt_status_image)

      status_item
    end
  end
end
