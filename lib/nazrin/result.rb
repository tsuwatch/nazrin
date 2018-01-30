module Nazrin
  class Result < SimpleDelegator
    attr_reader :facets

    def initialize(result, facets)
      super(result)
      @facets = facets
    end
  end
end
