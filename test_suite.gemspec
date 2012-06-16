# -*- encoding: utf-8 -*-
require File.expand_path('../lib/test_suite/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["iain"]
  gem.email         = ["iain@iain.nl"]
  gem.description   = %q{A manager for multiple test suites within one project}
  gem.summary       = %q{Define the commands and test suites that need to be run in your project and run them.}
  gem.homepage      = "https://github.com/iain/test_suite"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "test_suite"
  gem.require_paths = ["lib"]
  gem.version       = TestSuite::VERSION

  gem.add_development_dependency "rspec"
  gem.add_development_dependency "rake"

end
