require File.expand_path("../lib/lingohub/version", __FILE__)

Gem::Specification.new do |gem|
  gem.name    = "lingohub"
  gem.version = Lingohub::VERSION

  gem.author      = "lingohub GmbH"
  gem.email       = "team@lingohub.com"
  gem.homepage    = "https://lingohub.com"
  
  gem.summary     = "Client library and CLI to translate Ruby based apps with lingohub."
  gem.description = "Client library and command-line tool to translate Ruby based apps with lingohub."
  gem.executables = "lingohub"

  gem.required_rubygems_version = ">= 1.3.6"

  # If you need to check in files that aren't .rb files, add them here
  gem.files        = Dir["{lib}/**/*.rb", "bin/*", "LICENSE", "*.md"]
  gem.require_path = 'lib'

  gem.add_dependency "rest-client", ">= 1.4.0", "< 1.7.0"
  gem.add_dependency "launchy"
  gem.add_dependency "stringex", "~>1.2.1"
end