# -*- encoding: utf-8 -*-
require File.expand_path('../lib/menu-motion/version', __FILE__)

Gem::Specification.new do |spec|
  spec.name          = "menu-motion"
  spec.version       = MenuMotion::VERSION
  spec.authors       = ["Brian Pattison"]
  spec.email         = ["brian@brianpattison.com"]
  spec.summary       = "A RubyMotion wrapper for creating OS X status bar menus"
  spec.description   = "MenuMotion is a RubyMotion wrapper inspired by Formotion for creating OS X status bar menus with a syntax that should feel familiar if you've used Formotion."
  spec.homepage      = "https://github.com/codelation/menu-motion"
  spec.license       = "MIT"

  files = []
  files << "README.md"
  files.concat(Dir.glob('lib/**/*.rb'))
  spec.files         = files
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "rake"
end
