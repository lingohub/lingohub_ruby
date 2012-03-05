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

  # If you need to check in files that aren't .rb files, add them here
  gem.files        = Dir["{lib}/**/*.rb", "bin/*", "LICENSE", "*.md"]
  gem.require_paths = %w[lib]

  gem.add_dependency "rest-client", "~> 1.6.7"
  gem.add_dependency "launchy",     "~> 2.0.5"
  gem.add_dependency "stringex",    "~> 1.3.2"
end
