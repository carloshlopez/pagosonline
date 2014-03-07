# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "pagosonline/version"

Gem::Specification.new do |s|
  s.name        = "pagosonline"
  s.version     = Pagosonline::VERSION
  s.authors     = ["Sebastian Gamboa, Carlos Lopez"]
  s.email       = ["me@sagmor.com,carloshlopez@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{Pagosonline}
  s.description = %q{Pagosonline}

  s.rubyforge_project = "pagosonline"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency "hashie"
end
