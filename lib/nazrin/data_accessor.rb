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
        if defined?(::ActiveRecord::Base) && clazz.ancestors.include?(::ActiveRecord::Base)
          require 'nazrin/data_accessor/active_record'
          return Nazrin::DataAccessor::ActiveRecord
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

    def initialize(model, options)
      @model = model
      @options = options
    end

    def results(client)
      @client = client

      res = @client.search
      collection = load_all(res.data.hits.hit.map(&:id))

      if @client.parameters[:size] && @client.parameters[:start]
        total_count = res.data.hits.found

        Nazrin::PaginationGenerator.generate(
          collection,
          current_page: current_page,
          per_page: @client.parameters[:size],
          total_count: total_count,
          last_page: last_page(total_count))
      else
        collection
      end
    end

    def load_all
      raise NotImplementedError
    end

    private

    def last_page(total_count)
      (total_count / @client.parameters[:size].to_f).ceil
    end

    def current_page
      (@client.parameters[:start] / @client.parameters[:size].to_f).ceil + 1
    end
  end
end
