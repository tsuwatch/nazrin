module Nazrin
  module PaginationGenerator
    module NazrinGenerator
      def self.call(collection, options = {})
        Nazrin::PaginatedArray.new(
          collection,
          options[:current_page],
          options[:per_page],
          options[:total_count])
      end
    end
  end
end
