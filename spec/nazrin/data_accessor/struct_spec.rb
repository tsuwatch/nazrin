require 'spec_helper'

describe 'Nazrin::DataAccessor::Struct' do
  let(:clazz) do
    Class.new do
      def self.name; 'CustomStruct'; end
      include Nazrin::Searchable

      attr_reader :attributes

      searchable_configure do |config|
        config.domain_name = 'my-domain-name'
      end

      def initialize(attributes)
        @attributes = attributes
      end
    end
  end
  let(:data_accessor) { Nazrin::DataAccessor.for(clazz) }

  it do
    expect(data_accessor).to be < Nazrin::DataAccessor::Struct
  end
end
