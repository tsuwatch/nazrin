require 'aws-sdk-cloudsearch'

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

        def transform_attributes(attributes)
          attributes.each_with_object({}) do |(name, value), hash|
            type = field_types[name]

            if type.end_with?('array')
              hash[name] = value
            else
              hash[name] = value.first
            end
          end
        end

        def field_types
          return @field_types if defined?(@field_types)

          response = cloudsearch_client.describe_index_fields(
            domain_name: config.domain_name
          )

          @field_types = response.index_fields.each_with_object({}) do |field, fields|
            name = field.options[:index_field_name]
            type = field.options[:index_field_type]

            fields[name] = type
          end
        end

        private

        def cloudsearch_client
          @cloudsearch_client ||= Aws::CloudSearch::Client.new(
            region: config.region,
            access_key_id: config.access_key_id,
            secret_access_key: config.secret_access_key,
            logger: config.logger
          )
        end
      end

      def load_all(data)
        data.map do |attributes|
          model.new(attributes)
        end
      end

      def data_from_response(res)
        res.data[:hits][:hit].map do |hit|
          self.class.transform_attributes(
            { 'id' => hit[:id] }.merge(hit[:fields] || {})
          )
        end
      end
    end
  end
end
