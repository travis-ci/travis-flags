# encoding: utf-8

$:.unshift File.expand_path('../lib', __FILE__)
require 'travis/flags/version'

Gem::Specification.new do |s|
  s.name         = "travis-flags"
  s.version      = Travis::Flags::VERSION
  s.authors      = ["Travis CI"]
  s.email        = "contact@travis-ci.org"
  s.homepage     = "https://github.com/travis-ci/travis-flags"
  s.summary      = "Travis CI flags"
  s.description  = "#{s.summary}."
  s.license      = "MIT"

  s.files        = Dir['{lib/**/*,spec/**/*,[A-Z]*}']
  s.platform     = Gem::Platform::RUBY
  s.require_path = 'lib'
  s.rubyforge_project = '[none]'
end
