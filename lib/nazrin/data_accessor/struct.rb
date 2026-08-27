require 'nazrin/data_accessor/struct/attribute_transformer'

module Nazrin
  class DataAccessor
    class Struct < Nazrin::DataAccessor
      class MissingDomainNameConfigError < StandardError; end

      class << self
        attr_reader :config

        def [](config)
          Class.new(self).tap do |clazz|
            clazz.instance_variable_set(:@config, config)
          end
        end

        def attribute_transformer
          return @attribute_transformer if defined?(@attribute_transformer)

          if config.attribute_transformer
            @attribute_transformer = config.attribute_transformer
          else
            @attribute_transformer = AttributeTransformer.new(config)
          end
        end
      end

      def load_all(data)
        data.map do |attributes|
          model.new(attributes)
        end
      end

      def data_from_response(res)
        res.data[:hits][:hit].map do |hit|
          self.class.attribute_transformer.call(
            { 'id' => hit[:id] }.merge(hit[:fields] || {})
          )
        end
      end
    end
  end
end
