module Nazrin
  class DataAccessor
    class ActiveRecord < Nazrin::DataAccessor
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
    end
  end
end
