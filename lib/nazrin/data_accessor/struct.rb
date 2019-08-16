require 'nazrin/data_accessor/struct/attribute_transformer'
require 'active_support/core_ext/hash/except'

module Nazrin
  class DataAccessor
    class Struct < Nazrin::DataAccessor
      class MissingDomainNameConfigError < StandardError; end

      NAZRIN_HIGHLIGHTS_ITEM_KEY = 'highlights___'

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
          model.new(attributes.except(NAZRIN_HIGHLIGHTS_ITEM_KEY)).tap do |instance|
            instance.nazrin_highlights = ActiveSupport::OrderedOptions[attributes[NAZRIN_HIGHLIGHTS_ITEM_KEY].transform_keys(&:to_sym)]
          end
        end
      end

      def data_from_response(res)
        res.data[:hits][:hit].map do |hit|
          self.class.attribute_transformer.call(
            { 'id' => hit[:id] }.merge(
              hit[:fields] || {}
            ).merge(
              { NAZRIN_HIGHLIGHTS_ITEM_KEY => hit[:highlights] || {} }
            )
          )
        end
      end
    end
  end
end
