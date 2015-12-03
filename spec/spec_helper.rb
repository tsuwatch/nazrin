$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'coveralls'
Coveralls.wear!

require 'kaminari'
require 'aws-sdk'
require 'active_record'
require 'nazrin'

Kaminari::Hooks.init

Nazrin.configure do |config|
  config.debug_mode = false
  config.search_endpoint = 'http://search'
  config.document_endpoint = 'http://document'
  config.region = :region
  config.access_key_id = :access_key_id
  config.secret_access_key = :secret_access_key
  config.pagination = 'kaminari'
end

class FakeResponse
  def data
    self
  end

  def hits
    self
  end

  def hit
    [self]
  end

  def id
    1
  end

  def found
    1
  end
end

ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: ':memory:')

class Post < ActiveRecord::Base
  include Nazrin::ActiveRecord::Searchable

  searchable do
    fields [:content]
    field(:created_at) { created_at.utc.iso8601 }
  end
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
  end
end
