require 'active_support/concern'

module Nazrin
  module ActiveRecord
    module Searchable
      extend ActiveSupport::Concern

      included do
        alias_method :delete_from_index, :nazrin_delete_from_index unless method_defined? :delete_from_index
        alias_method :add_to_index, :nazrin_add_to_index unless method_defined? :add_to_index
        alias_method :update_in_index, :nazrin_update_in_index unless method_defined? :update_in_index
      end

      def nazrin_delete_from_index
        self.class.nazrin_delete_document(self)
      end

      def nazrin_add_to_index
        self.class.nazrin_add_document(self)
      end

      def nazrin_update_in_index
        self.class.nazrin_update_document(self)
      end

      module ClassMethods
        def self.extended(base)
          class << base
            alias_method :search, :nazrin_search unless method_defined? :search
            alias_method :searchable, :nazrin_searchable unless method_defined? :searchable
            alias_method :fields, :nazrin_fields unless method_defined? :fields
            alias_method :field, :nazrin_field unless method_defined? :field
          end
        end

        def nazrin_search(options = {})
          client = Nazrin::SearchClient.new
          client.data_accessor = Nazrin::ActiveRecord::DataAccessor.new(
            self, options)
          client
        end

        def nazrin_searchable(&block)
          class_variable_set(
            :@@nazrin_doc_client,
            Nazrin::DocumentClient.new)
          class_variable_set(:@@nazrin_search_field_data, {})
          block.call
        end

        def nazrin_fields(fields)
          field_data = class_variable_get(:@@nazrin_search_field_data)
          fields.each do |field|
            field_data[field] = proc { public_send(field) }
          end
          class_variable_set(:@@nazrin_search_field_data, field_data)
        end

        def nazrin_field(field, &block)
          field_data = class_variable_get(:@@nazrin_search_field_data)
          field_data[field] = block
          class_variable_set(:@@nazrin_search_field_data, field_data)
        end

        def nazrin_doc_client
          class_variable_get(:@@nazrin_doc_client)
        end

        def nazrin_eval_field_data(obj)
          data = {}
          class_variable_get(
            :@@nazrin_search_field_data).each do |field, block|
              data[field] = obj.instance_eval(&block)
              data[field] = data[field].remove(
                /[[:cntrl:]]/) if data[field].is_a?(String)
            end
          data
        end

        def nazrin_add_document(obj)
          nazrin_doc_client.add_document(
            nazrin_get_document_id(obj), nazrin_eval_field_data(obj))
        end

        def nazrin_update_document(obj)
          nazrin_add_document(obj)
        end

        def nazrin_delete_document(obj)
          nazrin_doc_client.delete_document(nazrin_get_document_id(obj))
        end

        def nazrin_get_document_id(obj)
          obj.class.to_s + "." + obj.send(:id).to_s
        end
      end
    end
  end
end
