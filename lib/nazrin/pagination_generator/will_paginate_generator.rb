module Nazrin
  module PaginationGenerator
    module WillPaginateGenerator
      def self.call(collection, options)
        begin
          require 'will_paginate/collection'
        rescue LoadError
          abort "Missing dependency 'will_paginate' for pagination"
        end

        WillPaginate::Collection.create(options[:current_page], options[:per_page], options[:total_count]) do |pager|
          pager.replace collection[pager.offset, pager.per_page].to_a
        end
      end
    end
  end
end
