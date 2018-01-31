# Nazrin
[![Gem Version](https://badge.fury.io/rb/nazrin.svg)](https://badge.fury.io/rb/nazrin)
[![Build Status](https://travis-ci.org/tsuwatch/nazrin.svg?branch=master)](https://travis-ci.org/tsuwatch/nazrin)
[![Coverage Status](https://coveralls.io/repos/tsuwatch/nazrin/badge.svg?branch=readme&service=github)](https://coveralls.io/github/tsuwatch/nazrin?branch=readme)
[![Code Climate](https://codeclimate.com/github/tsuwatch/nazrin/badges/gpa.svg)](https://codeclimate.com/github/tsuwatch/nazrin)

Nazrin is a Ruby wrapper for Amazon CloudSearch (aws-sdk), with ActiveRecord, Mongoid support for easy integration with your Rails application.

>*Nazrin has the ability of the extent which find what you're looking for...*

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'nazrin'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install nazrin

## Usage

### in Ruby on Rails

```ruby
$ bundle exec rails g nazrin:config # execute before including nazrin to model

Nazrin.configure do |config|
  config.debug_mode = false
  config.mode = 'production'
  config.search_endpoint = ''
  config.document_endpoint = ''
  config.region = ''
  config.access_key_id = ''
  config.secret_access_key = ''
  config.logger = nil
end
```

```ruby
class Post < ActiveRecord::Base
  include Nazrin::Searchable

  # You can override settings
  searchable_configure do |config|
    config.search_endpoint = 'http://example.com/override-search-endpoint'
    config.document_endpoint = 'http://example.com/override-document-endpoint'

    # If you set domain_name, CloudSearch data using index_fields configured for the search domain is loaded, not a database.
    # So you can use nazrin for plain object
    config.domain_name = 'my-cloudsearch-domain-name'
  end

  searchable do
    fields [:content]
    field(:created_at) { created_at.utc.iso8601 }
  end

  after_create :add_to_index
  after_update :update_in_index
  after_destroy :delete_from_index
end
```

```ruby
result = Post.search(where: :foo, includes: :bar).size(1).start(0).query("(and 'content')").query_parser('structured').execute
=> [#<Post id: 1, content: "content">]
# You can access facets
result.facets
=> {}
```

### Supported pagination libraries
If you want to use other supported pagination libraries, for example, `nazrin-kaminari` generates `Kaminari::PaginatableArray` instead of `Nazrin::PaginatedArray`.

```ruby
gem 'nazrin'
gem 'nazrin-kaminari'
```

Currently supported libraries

- kaminari: [nazrin-kaminari](https://github.com/tsuwatch/nazrin-kaminari)

### Sandbox mode

When there is no instance for development and you don't want to request to CloudSearch

```ruby
Nazrion.config.mode = 'sandbox'
```

"sandbox" mode where it does nothing with any requests and just returns an empty collection for any searches.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/[my-github-username]/nazrin/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
