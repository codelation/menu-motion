# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require "motion/project/template/osx"
require "./lib/menu_motion"

begin
  require "bundler"
  require "motion/project/template/gem/gem_tasks"
  Bundler.require
rescue LoadError
end

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = "MenuMotion"
  app.info_plist["NSHumanReadableCopyright"] = "Copyright © 2014 Brian Pattison. All rights reserved."
end
