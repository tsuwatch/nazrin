module Nazrin
  class PaginatedArray < Array
    attr_reader :current_page, :per_page, :total_count

    def initialize(collection, page, per_page, total_count)
      @current_page = page
      @per_page = per_page
      @total_count = total_count
      replace collection
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
end
