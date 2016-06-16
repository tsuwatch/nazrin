module Nazrin
  module PaginationGenerator
    module KaminariGenerator
      def self.call(collection, options)
        begin
          require 'kaminari'
        rescue LoadError
          abort "Missing dependency 'kaminari' for pagination"
        end
        Kaminari.paginate_array(collection, total_count: options[:total_count])
          .page(options[:current_page])
          .per(options[:per_page]).tap do |paginate_array|
            paginate_array.max_pages_per(options[:last_page])
          end
      end
    end
  end
end
