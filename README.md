# Nazrin
[![Gem Version](https://badge.fury.io/rb/nazrin.svg)](https://badge.fury.io/rb/nazrin)
[![Build Status](https://travis-ci.org/tsuwatch/nazrin.svg?branch=master)](https://travis-ci.org/tsuwatch/nazrin)
[![Coverage Status](https://coveralls.io/repos/tsuwatch/nazrin/badge.svg?branch=readme&service=github)](https://coveralls.io/github/tsuwatch/nazrin?branch=readme)
[![Code Climate](https://codeclimate.com/github/tsuwatch/nazrin/badges/gpa.svg)](https://codeclimate.com/github/tsuwatch/nazrin)

Nazrin is a Ruby wrapper for Amazon CloudSearch (aws-sdk), with optional ActiveRecord support for easy integration with your Rails application.

*Nazrin has the ability of the extent which find what you're looking for...*

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
$ bundle exec rails g nazrin:config

Nazrin.config do |config|
  config.debug_mode = false
  config.search_endpoint = ''
  config.document_endpoint = ''
  config.region = ''
  config.access_key_id = ''
  config.secret_access_key = ''
  # currently support kaminari gem
  config.pagination = 'kaminari'
end
```

```ruby
class Post
  include Nazrin::ActiveRecord::Searchable

  searchable do
    fields [:content]
    field(:created_at) { created_at.utc.iso8601 }
  end

  after_create :update_in_index
  after_destroy :delete_from_index
end
```

```ruby
Post.search.size(1).start(0).query("(and 'content')").query_parser('structured').execute
=> [#<Post id: 1, content: "content">]
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/[my-github-username]/nazrin/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
