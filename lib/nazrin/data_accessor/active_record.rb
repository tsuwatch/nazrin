module Nazrin
  class DataAccessor
    class ActiveRecord < Nazrin::DataAccessor
      # load from activerecord
      def load_all(ids)
        records_table = {}

        relation = options.reduce(model) do |rel, (k, v)|
          rel.send(k, v)
        end

        relation.where(id: ids).each do |record|
          records_table[record.id.to_s] = record
        end

        records_table.values_at(*ids.map(&:to_s)).compact
      end

      def data_from_response(res)
        res.data.hits.hit.map(&:id)
      end
    end
  end
end
