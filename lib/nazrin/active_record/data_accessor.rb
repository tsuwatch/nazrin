module Nazrin
  module ActiveRecord
    class DataAccessor
      MAX_LIMIT = 10_000

      def initialize(model, options)
        @model = model
        @options = options
      end

      # a list of all matching AR model objects
      def results(client)
        @client = client

        res = @client.search
        collections = load_all(res.data.hits.hit.map(&:id))
        if @client.parameters[:size] && @client.parameters[:start]
          round_correct_page

          Nazrin.paginated_array(
            collections,
            current_page: @current_page,
            per_page: @client.parameters[:size],
            total_count: res.data.hits.found,
            last_page: @last_page)
        else
          collections
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

      def round_correct_page
        res = search_for_set_correct_page
        total_count = res.data.hits.found
        if over_max_limit_request?
          if total_count > MAX_LIMIT
            @current_page = @last_page = get_last_page(MAX_LIMIT)
          else
            @current_page = @last_page = get_last_page(total_count)
          end
          @client.start(get_start_position(@current_page))
        elsif res.data.hits.found > 0 && !res.data.hits.hit.present?
          @current_page = @last_page = get_last_page(total_count)
          @client.start(get_start_position(@current_page))
        else
          @current_page = (
            @client.parameters[:start] / @client.parameters[:size].to_f
          ).ceil + 1
          @last_page = get_last_page(total_count)
        end
      end

      def search_for_set_correct_page
        if over_max_limit_request?
          tmp_start = @client.parameters[:start]
          res = @client.start(0).search
          @client.start(tmp_start)
        else
          res = @client.search
        end
        res
      end

      def over_max_limit_request?
        return false unless @client.parameters[:start].present?
        return false unless @client.parameters[:size].present?
        if @client.parameters[:start] + @client.parameters[:size] > MAX_LIMIT
          true
        else
          false
        end
      end

      def get_last_page(total_count)
        (total_count / @client.parameters[:size].to_f).ceil
      end

      def get_start_position(current_page)
        (current_page - 1) * @client.parameters[:size]
      end
    end
  end
end
