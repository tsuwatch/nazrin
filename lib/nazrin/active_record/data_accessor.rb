module Nazrin
  module ActiveRecord
    class DataAccessor
      def initialize(model, options)
        @model = model
        @options = options
      end

      # a list of all matching AR model objects
      def results(client)
        @client = client

        res = @client.search
        collection = load_all(res.data.hits.hit.map{|x| if x.id.include?(".") then x.id.split(".")[1] else x.id end })

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

      # load from activerecord
      def load_all(ids)
        records_table = {}
        @options.each do |k, v|
          @model = @model.send(k, v)
        end
        @model.where(id: ids).each do |record|
          records_table[record.id] = record
        end
        ids.map do |id|
          records_table.select { |k, _| k == id.to_i }[id.to_i]
        end.reject(&:nil?)
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
end
