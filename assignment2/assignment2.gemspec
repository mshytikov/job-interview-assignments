# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'assignment2/version'

Gem::Specification.new do |spec|
  spec.name          = "assignment2"
  spec.version       = Assignment2::VERSION
  spec.authors       = ["Max Shytikov"]
  spec.email         = ["mshytikov@gmail.com"]
  spec.description   = "Assignment 2"
  spec.summary       = "Assignment 2"
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
