module Nazrin
  class DataAccessor
    class Mongoid < Nazrin::DataAccessor
      def load_all(ids)
        documents_table = {}
        options.each do |k, v|
          model = if v.nil?
                     model.send(k)
                   else
                     model.send(k, v)
                   end
        end
        model.where('_id' => { '$in' => ids }).each do |document|
          documents_table[document._id.to_s] = document
        end
        ids.map do |id|
          documents_table[id]
        end.reject(&:nil?)
      end

      def data_from_response(res)
        res.data.hits.hit.map(&:id)
      end
    end
  end
end
