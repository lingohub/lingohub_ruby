require File.expand_path("../lib/linguist_ruby/version", __FILE__)

Gem::Specification.new do |gem|
  gem.name    = "linguist_ruby"
  gem.version = Linguist::VERSION

  gem.author      = "Linguist"
  gem.email       = "support@lingui.st"
  gem.homepage    = "http://lingui.st/"
  
  gem.summary     = "Client library and CLI to translate Rails apps with Linguist."
  gem.description = "Client library and command-line tool to translate Rails apps with Linguist."
  gem.executables = "linguist"

  gem.required_rubygems_version = ">= 1.3.6"

  # If you need to check in files that aren't .rb files, add them here
  gem.files        = Dir["{lib}/**/*.rb", "bin/*", "LICENSE", "*.md"]
  gem.require_path = 'lib'

  gem.add_dependency "rest-client", ">= 1.4.0", "< 1.7.0"
  gem.add_dependency "launchy"
  gem.add_dependency "stringex", "~>1.2.1"
end
