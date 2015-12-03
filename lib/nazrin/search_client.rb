module Nazrin
  class SearchClient
    attr_accessor :data_accessor
    attr_reader :parameters

    def initialize
      @client = Aws::CloudSearchDomain::Client.new(
        endpoint: Nazrin.config.search_endpoint,
        region: Nazrin.config.region,
        access_key_id: Nazrin.config.access_key_id,
        secret_access_key: Nazrin.config.secret_access_key)
      @parameters = {}
    end

    # query
    # @param [String] query query string
    def query(query)
      @parameters[:query] = query
      self
    end

    # return fields
    # @param [Array<String>] fields ex) ['title']
    def return(fields)
      @parameters[:return] = fields.join(',')
      self
    end

    # set the number to get
    # @param [Integer] size the number to get
    def size(size)
      @parameters[:size] = size
      self
    end

    # set the parser to be used
    # @param [String] parser 'simple', 'structured', 'lucene', dismax'
    def query_parser(query_parser)
      @parameters[:query_parser] = query_parser
      self
    end

    # set the search start position
    # @param [Integer] start start position
    def start(start)
      @parameters[:start] = start
      self
    end

    # set the cursor
    # @param [String] cursor cursor
    def cursor(cursor)
      @parameters[:cursor] = cursor
      self
    end

    # sort
    # @param [Array<String>] sorts ex) ['year desc']
    def sort(sorts)
      @parameters[:sort] = sorts.join(',')
      self
    end

    # partial
    # @param [Boolean] partial true or false
    def partial(partial)
      @parameters[:partial] = partial
      self
    end

    # query filtering
    # @param [String] filter_query "tags:'aaa'"
    def filter_query(filter_query)
      @parameters[:filter_query] = filter_query
      self
    end

    # query options
    # @param [String] query_options ex) target field "{fields:['title']}"
    def query_options(query_options)
      @parameters[:query_options] = query_options
      self
    end

    # highlight
    # @param [String] highlight "{'tags':{}}"
    def highlight(highlight)
      @parameters[:highlight] = highlight
      self
    end

    # facet
    # @param [String] facet ex) "{'year':{'sort':'bucket'}}"
    def facet(facet)
      @parameters[:facet] = facet
      self
    end

    # define any expression
    # @param [String] expr ex) "{'EXPRESSIONNAME':'EXPRESSION'}"
    def expr(expr)
      @parameters[:expr] = expr
      self
    end

    def search
      @client.search(@parameters)
    end

    def execute
      if data_accessor
        data_accessor.results(self)
      else
        search
      end
    end
  end
end
