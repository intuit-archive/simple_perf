# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "simple_perf/version"

Gem::Specification.new do |s|
  s.name        = "simple_perf"
  s.version     = SimplePerf::VERSION
  s.authors     = ["Jimmy Armitage"]
  s.email       = ["mrjimmy410@gmail.com"]
  s.homepage    = "http://www.example.com"
  s.summary     = %q{I help with performance testing}
  s.description = %q{I am designed to control a JMeter army of AWS EC2 instances}

  s.rubyforge_project = "simple_perf"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency "rake"
  s.add_development_dependency "rspec", "~> 2.11.0"

  s.add_runtime_dependency "trollop", "2.0"
  s.add_runtime_dependency "simple_deploy", "0.7.2"
  s.add_runtime_dependency "aws-sdk", ">= 1.9.5"
end
