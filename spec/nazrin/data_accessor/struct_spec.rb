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

  describe '.field_types' do
    let(:cs_client) do
      instance_double(Aws::CloudSearch::Client)
    end
    let(:index_fields_response) { double(index_fields: index_fields) }
    let(:index_fields) do
      [id_field, name_field, tags_field]
    end
    let(:id_field) do
      double(
        options: {
          index_field_name: 'id',
          index_field_type: 'int'
        }
      )
    end
    let(:name_field) do
      double(
        options: {
          index_field_name: 'name',
          index_field_type: 'text'
        }
      )
    end
    let(:tags_field) do
      double(
        options: {
          index_field_name: 'tags',
          index_field_type: 'literal-array'
        }
      )
    end

    before do
      allow(Aws::CloudSearch::Client).to receive(:new).and_return(
        cs_client
      )
      allow(cs_client).to receive(:describe_index_fields).and_return(
        index_fields_response
      )
    end

    it do
      expect(Aws::CloudSearch::Client).to receive(:new).with(
        access_key_id: Nazrin.config.access_key_id,
        secret_access_key: Nazrin.config.secret_access_key,
        logger: Nazrin.config.logger
      )
      expect(cs_client).to receive(:describe_index_fields).with(
        domain_name: 'my-domain-name'
      )
      expect(data_accessor.field_types).to eq(
        'id' => 'int',
        'name' => 'text',
        'tags' => 'literal-array'
      )
    end
  end

  describe '.transform_attributes' do
    let(:attributes) do
      {
        'id' => ['1'],
        'name' => ['Michael'],
        'tags' => ['one', 'two', 'three']
      }
    end

    before do
      allow(data_accessor).to receive(:field_types).and_return(
        'id' => 'int',
        'name' => 'text',
        'tags' => 'literal-array'
      )
    end

    it do
      expect(data_accessor.transform_attributes(attributes)).to eq(
        'id' => '1',
        'name' => 'Michael',
        'tags' => ['one', 'two', 'three']
      )
    end
  end
end
