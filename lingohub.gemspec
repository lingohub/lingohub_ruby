# -*- encoding: utf-8 -*-

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

  gem.add_dependency('rest-client', '~> 1.6.7')
  gem.add_dependency('launchy',     '~> 2.0.5')
  gem.add_dependency('stringex',    '~> 1.3.2')

  # gem.add_development_dependency('rake',    '~> 0.9.2')
  # gem.add_development_dependency('rspec',   '~> 2.8.0')
  # gem.add_development_dependency('fakefs',  '~> 0.4.0')
  # gem.add_development_dependency('taps',    '~> 0.3.23')
  # gem.add_development_dependency('webmock', '~> 1.8.0')
end
