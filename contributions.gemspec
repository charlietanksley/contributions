# -*- encoding: utf-8 -*-
require File.expand_path('../lib/contributions/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Charlie Tanksley"]
  gem.email         = ["charlie.tanksley@gmail.com"]
  gem.description   = %q{Gather your contributions to OSS projects (hosted on github!).}
  gem.summary       = %q{A gem to find all your contributions to OSS projects on github and make that information easy to access.}
  gem.homepage      = "http://charlietanksley.github.com/contributions/"

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "contributions"
  gem.require_paths = ["lib"]
  gem.version       = Contributions::VERSION

  gem.add_dependency('json')

  gem.add_development_dependency('riot')
  gem.add_development_dependency('rake')
end
