module Nazrin
  module PaginationGenerator
    SUPPORTED_PAGINATION_GEMS = %w(nazrin kaminari will_paginate)

    class << self
      def generate(collection, options = {})
        abort "#{Nazrin.config.pagination} is not supported gem of pagination" unless SUPPORTED_PAGINATION_GEMS.include?(Nazrin.config.pagination.to_s)

        retreive_generator_module.call(collection, options)
      end

      private

      def retreive_generator_module
        require "nazrin/pagination_generator/#{Nazrin.config.pagination}_generator"
        Nazrin::PaginationGenerator.const_get("#{Nazrin.config.pagination.to_s.camelize}Generator")
      end
    end
  end
end
