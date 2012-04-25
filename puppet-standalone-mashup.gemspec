# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "puppet-standalone-mashup/version"

Gem::Specification.new do |s|
  s.name        = "puppet-standalone-mashup"
  s.version     = Puppet::Standalone::Mashup::VERSION
  s.authors     = ["John Bintz"]
  s.email       = ["john@coswellproductions.com"]
  s.homepage    = ""
  s.summary     = %q{TODO: Write a gem summary}
  s.description = %q{TODO: Write a gem description}

  s.rubyforge_project = "puppet-standalone-mashup"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency 'vagrant'
  s.add_runtime_dependency 'capistrano'
  s.add_runtime_dependency 'capistrano-ext'

  s.add_runtime_dependency 'net-ssh'
  s.add_runtime_dependency 'rspec'
  s.add_runtime_dependency 'cucumber'
  s.add_runtime_dependency 'guard'
  s.add_runtime_dependency 'guard-cucumber'
end
