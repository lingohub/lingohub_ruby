require File.expand_path("../lib/linguist/version", __FILE__)

Gem::Specification.new do |gem|
  gem.name    = "linguist"
  gem.version = Linguist::VERSION

  gem.author = "Linguist"
  gem.email       = "support@lingui.st"
  gem.homepage    = "http://lingui.st/"
  gem.summary     = "Client library and CLI to translate Rails apps with Linguist."
  gem.description = "Client library and command-line tool to translate Rails apps with Linguist."
  gem.executables = "linguist_ruby"

  gem.required_rubygems_version = ">= 1.3.6"

  # If you have other dependencies, add them here
  # s.add_dependency "another", "~> 1.2"

  # If you need to check in files that aren't .rb files, add them here
  gem.files = Dir["{lib}/**/*.rb", "bin/*", "LICENSE", "*.md"]
  gem.require_path = 'lib'

  gem.add_development_dependency "fakefs",  "~> 0.3.1"
  gem.add_development_dependency "rake"
  gem.add_development_dependency "rspec",   "~> 1.3.0"
  gem.add_development_dependency "taps",    "~> 0.3.20"
  gem.add_development_dependency "webmock", "~> 1.5.0"

  gem.add_dependency "rest-client", ">= 1.4.0", "< 1.7.0"
  gem.add_dependency "launchy",     "~> 0.3.2"
end
