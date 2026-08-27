module Nazrin
  class Result < SimpleDelegator
    attr_reader :facets
    attr_reader :highlights

    def initialize(result, facets, highlights)
      super(result)
      @facets = facets
      @highlights = highlights
    end
  end
end
