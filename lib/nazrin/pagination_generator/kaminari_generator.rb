module Nazrin
  module PaginationGenerator
    module KaminariGenerator
      def self.call(collection, options)
        begin
          require 'kaminari'
        rescue LoadError
          abort "Missing dependency 'kaminari' for pagination"
        end
        Kaminari.config.max_pages = options[:last_page]
        Kaminari.paginate_array(collection, total_count: options[:total_count])
          .page(options[:current_page])
          .per(options[:per_page])
      end
    end
  end
end
