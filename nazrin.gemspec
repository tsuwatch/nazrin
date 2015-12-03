# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'nazrin/version'

Gem::Specification.new do |spec|
  spec.name          = 'nazrin'
  spec.version       = Nazrin::VERSION
  spec.authors       = ['Tomohiro Suwa']
  spec.email         = ['neoen.gsn@gmail.com']

  spec.summary       = 'Amazon CloudSearch client'
  spec.description   = 'Amazon CloudSearch client'
  spec.homepage      = 'https://github.com/tsuwatch/nazrin'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.require_paths = ['lib']

  spec.add_dependency 'aws-sdk', '~> 2'

  spec.add_development_dependency 'bundler', '~> 1.9'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'kaminari'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'coveralls'
  spec.add_development_dependency 'sqlite3'
  spec.add_development_dependency 'activerecord'
  spec.add_development_dependency 'database_cleaner'
end
