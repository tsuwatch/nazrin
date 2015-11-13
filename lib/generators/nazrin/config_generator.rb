module Nazrin
  module Generators
    class ConfigGenerator < Rails::Generators::Base
      source_root File.expand_path(
        File.join(File.dirname(__FILE__), 'templates'))
      desc 'Generate config'

      def config
        template 'nazrin_config.rb', 'config/initializers/nazrin_config.rb'
      end
    end
  end
end
