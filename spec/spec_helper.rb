$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'coveralls'
Coveralls.wear!

require 'active_record'
require 'mongoid'
require 'nazrin'

Nazrin.configure do |config|
  config.debug_mode = false
  config.mode = 'production'
  config.search_endpoint = 'http://search.com'
  config.document_endpoint = 'http://document.com'
  config.region = 'region'
  config.access_key_id = 'access_key_id'
  config.secret_access_key = 'secret_access_key'
end

class FakeResponse
  attr_accessor :id

  def initialize(id = 1)
    self.id = id
  end

  def data
    self
  end

  def hits
    self
  end

  def hit
    [self]
  end

  def found
    1
  end

  def facets
    nil
  end
end

class FakeResponseWithFacets < FakeResponse
  def facets
    {
      'status' => {
        'buckets' => [
          {
            'value' => 'active',
            'count' => 1
          }
        ]
      }
    }
  end
end

ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: ':memory:')

class Post < ActiveRecord::Base
  include Nazrin::Searchable

  searchable do
    fields [:content]
    field(:created_at) { created_at.utc.iso8601 }
  end
end

ENV['MONGOID_ENV'] = 'test'
Mongoid.load!('./spec/config/mongoid.yml')

class User
  include Mongoid::Document
  include Nazrin::Searchable

  field :email, type: String
  field :created_at, type: DateTime
end

ActiveRecord::Migration.verbose = false
ActiveRecord::Migrator.migrate File.expand_path('../db/migrate', __FILE__), nil

require 'database_cleaner'

RSpec.configure do |config|
  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
    Mongoid.purge!
  end
end
