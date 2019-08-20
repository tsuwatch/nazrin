require 'nazrin/result'

module Nazrin
  class DataAccessor
    class NoAccessorError < StandardError; end

    class << self
      def for(clazz)
        accessor = registered_accessor_for(clazz) || register_accessor(clazz)
        return accessor if accessor
        raise NoAccessorError, "No accessor for #{clazz.name}"
      end

      def registered_accessor_for(clazz)
        return nil if clazz.name.nil? || clazz.name.empty?
        accessors[clazz.name.to_sym]
      end

      def register_accessor(clazz)
        clazz.ancestors.each do |ancestor_class|
          if accessor = accessor_for(ancestor_class)
            register(accessor, clazz)
            return accessor
          end
        end
        nil
      end

      def accessor_for(clazz)
        return nil if clazz.name.nil? || clazz.name.empty?

        if clazz.respond_to?(:nazrin_searchable_config) && clazz.nazrin_searchable_config.domain_name
          require 'nazrin/data_accessor/struct'
          return Nazrin::DataAccessor::Struct[clazz.nazrin_searchable_config]
        elsif defined?(::ActiveRecord::Base) && clazz.ancestors.include?(::ActiveRecord::Base)
          require 'nazrin/data_accessor/active_record'
          return Nazrin::DataAccessor::ActiveRecord
        elsif defined?(::Mongoid::Document) && clazz.ancestors.include?(::Mongoid::Document)
          require 'nazrin/data_accessor/mongoid'
          return Nazrin::DataAccessor::Mongoid
        end
        nil
      end

      def register(accessor, clazz)
        accessors[clazz.name.to_sym] = accessor
      end

      def accessors
        @accessor ||= {}
      end
    end

    attr_reader :model
    attr_reader :options

    def initialize(model, options)
      @model = model
      @options = options
    end

    def results(client)
      res = client.search
      collection = load_all(data_from_response(res))
      start = client.parameters[:start]
      size = client.parameters[:size]

      if size && start
        total_count = res.data.hits.found

        records = Nazrin::PaginationGenerator.generate(
          collection,
          current_page: current_page(start, size),
          per_page: size,
          total_count: total_count,
          last_page: last_page(size, total_count))
      else
        records = collection
      end

      Result.new(
        records,
        res.facets,
        res.data.hits.hit.map { |hit| hit[:highlights] }
      )
    end

    def load_all
      raise NotImplementedError
    end

    def data_from_response
      raise NotImplementedError
    end

    private

    def last_page(size, total_count)
      (total_count / size.to_f).ceil
    end

    def current_page(start, size)
      (start / size.to_f).ceil + 1
    end
  end
end
