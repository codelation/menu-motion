# MenuMotion

[![Build Status](https://travis-ci.org/codelation/menu-motion.svg)](https://travis-ci.org/codelation/menu-motion)
[![Code Climate](https://codeclimate.com/github/codelation/menu-motion.png)](https://codeclimate.com/github/codelation/menu-motion)

MenuMotion is a RubyMotion wrapper inspired by Formotion for creating OS X status bar menus with a syntax that should feel familiar if you've used Formotion.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "menu-motion"
```

And then execute:

```sh
$ bundle
```

Or install it yourself as:

```sh
$ gem install menu-motion
```

## Usage

Here's an awesome graphic of a menu:

```
|‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾|
| [icon] First Item > |‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾|
|---------------------| First Subitem > |‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾|
| About MenuMotion    |-----------------| First Action  |
| Quit                | Some Action     | Second Action |
|_____________________|_________________|_______________|
```

And the Ruby to generate this menu:

```ruby
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
            action: "second_action"
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
```

### Sections

Sections are used to add dividers between sets of "rows" (menu items).

```ruby
menu = MenuMotion::Menu.new({
  sections: [{
    rows: []
  }, {
    rows: []
  }
})
```

### Submenus

To link a menu item to a submenu, simply define sections
or rows within the row item that should display the submenu.

```ruby
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
```

### Actions

Adding an action to a menu item is easy. Just define the
target and action.

```ruby
menu = MenuMotion::Menu.new({
  rows: [{
    title: "Basic Action",
    target: self,
    action: "basic_action"
  }, {
    title: "Pass the menu item to the action",
    target: self,
    action: "action_with_sender:"
  }]
})

def basic_action
  puts "Hello World"
end

def action_with_sender(sender)
  puts "Hello from #{sender}"
end
```

### Updating Menu Items

Assign keys to menu items that will need to be updated.

```ruby
menu = MenuMotion::Menu.new({
  rows: [{
    title: "Menu item",
    key: :main_item
    rows: [{
      title: "Submenu item 1",
      key: :submenu_item1,
      target: self,
      action: "do_something:"
    }, {
      title: "Submenu item 2",
      key: :submenu_item2,
      target: self,
      action: "do_something:"
    }]
  }]
})

# Let's update the first item's title:
menu.update(:main_item, {
  title: "Hello World"
})

# And give the first submenu item a submenu.
# The target and action will not be used if a submenu is defined.
menu.update(:submenu_item1, {
  rows: [{
    title: "Click me",
    target: self,
    action: "clicked"
  }]
})
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am "Add some feature"`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
