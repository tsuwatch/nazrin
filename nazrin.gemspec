# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'nazrin/version'

Gem::Specification.new do |spec|
  spec.name          = 'nazrin'
  spec.version       = Nazrin::VERSION
  spec.authors       = ['Tomohiro Suwa']
  spec.email         = ['neoen.gsn@gmail.com']

  spec.summary       = 'Ruby wrapper for Amazon CloudSearch (aws-sdk)'
  spec.description   = 'Ruby wrapper for Amazon CloudSearch (aws-sdk), with ActiveRecord, Mongoid support for easy integration with your Rails application'
  spec.homepage      = 'https://github.com/tsuwatch/nazrin'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.require_paths = ['lib']

  spec.add_dependency 'aws-sdk-core', '~> 3'
  spec.add_dependency 'aws-sdk-cloudsearchdomain', '~> 1.0'
  spec.add_dependency 'activesupport', '>= 4.0.0'

  spec.add_development_dependency 'bundler', '~> 1.9'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'coveralls'
  spec.add_development_dependency 'sqlite3'
  spec.add_development_dependency 'activerecord'
  spec.add_development_dependency 'database_cleaner'
  spec.add_development_dependency 'mongoid'
end
