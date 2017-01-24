require 'active_support/configurable'

module Nazrin
  def self.config
    @config ||= Nazrin::Configuration.new
  end

  def self.configure
    yield config if block_given?
  end

  class Configuration
    include ActiveSupport::Configurable
    config_accessor :debug_mode
    config_accessor :mode
    config_accessor :search_endpoint
    config_accessor :document_endpoint
    config_accessor :region
    config_accessor :access_key_id
    config_accessor :secret_access_key
  end
end
