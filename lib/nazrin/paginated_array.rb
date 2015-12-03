module Nazrin
  class PaginatedArray < Array
    attr_reader :current_page, :per_page, :total_count

    def initialize(collections, page, per_page, total_count)
      @current_page = page
      @per_page = per_page
      @total_count = total_count
      replace collections
    end

    # first page of the collections?
    def first_page?
      current_page == 1
    end

    # last page of the collections?
    def last_page?
      current_page >= total_pages
    end

    # total number of pages
    def total_pages
      (total_count.to_f / per_page).ceil
    end

    # previous page number in the collections
    def previous_page
      current_page - 1 unless first_page? || out_of_bounds?
    end

    # next page number in the collections
    def next_page
      current_page + 1 unless last_page? || out_of_bounds?
    end

    # out of bounds of the collections?
    def out_of_bounds?
      current_page > total_pages
    end
  end

  # create paginated collection
  def self.paginated_array(collections, options = {})
    if Nazrin.config.pagination == 'kaminari'
      begin
        require 'kaminari'
      rescue LoadError
        abort "Missing dependency 'kaminari' for pagination"
      end
      Kaminari.config.max_pages = options[:last_page]
      Kaminari.paginate_array(collections, total_count: options[:total_count])
        .page(options[:current_page])
        .per(options[:per_page])
    else
      Nazrin::PaginatedArray.new(
        collections,
        options[:current_page],
        options[:per_page],
        options[:total_count])
    end
  end
end
