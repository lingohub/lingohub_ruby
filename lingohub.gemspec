require File.expand_path("../lib/lingohub/version", __FILE__)

Gem::Specification.new do |gem|
  gem.name          = 'lingohub'
  gem.version       = Lingohub::VERSION
  gem.authors       = [ 'lingohub GmbH' ]
  gem.email         = [ 'team@lingohub.com' ]
  gem.description   = 'Client library and command-line tool to translate Ruby based apps with lingohub.'
  gem.summary       = gem.description
  gem.homepage      = 'https://lingohub.com'
  gem.executables   = 'lingohub'

  gem.require_paths = %w[lib]
  gem.files         = Dir['{lib}/**/*.rb', 'bin/*', 'LICENSE', '*.md']

  gem.add_dependency 'rest-client', '~> 1.6.7'
  gem.add_dependency 'launchy',     '~> 2.0.5'
  gem.add_dependency 'stringex',    '~> 1.3.2'
end
