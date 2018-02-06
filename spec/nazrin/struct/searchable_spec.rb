require 'spec_helper'

describe Nazrin::Searchable do
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

  describe '.nazrin_batch_operation' do
    let(:clazz) do
      Class.new(super()) do
        %i(id content created_at).each do |attr|
          define_method(attr) { attributes[attr] }
        end
      end
    end
    let(:added_struct_1) do
      clazz.new(id: 1, content: 'added_1', created_at: Time.now)
    end
    let(:added_struct_2) do
      clazz.new(id: 2, content: 'added_2', created_at: Time.now)
    end
    let(:deleted_struct_1) do
      clazz.new(id: 3, content: 'deleted_1', created_at: Time.now)
    end
    let(:domain_client) do
      instance_double(Aws::CloudSearchDomain::Client)
    end

    before do
      allow(data_accessor).to receive(:field_types).and_return(
        'id' => 'int',
        'content' => 'text',
        'created_at' => 'date'
      )
      allow(Aws::CloudSearchDomain::Client).to receive(:new)
        .and_return(domain_client)
      allow(domain_client).to receive(:upload_documents)
      # Hacky method to reset CS domain client
      clazz.class_eval do
        searchable  do
          fields [:content]
          field(:created_at) { created_at.utc.iso8601 }
        end
      end
    end

    subject do
      clazz.nazrin_batch_operation(
        add: [added_struct_1, added_struct_2],
        delete: [deleted_struct_1]
      )
    end

    it do
      expect(domain_client).to receive(:upload_documents).with(
        documents: [
          {
            type: 'add',
            id: added_struct_1.id,
            fields: {
              content: added_struct_1.content,
              created_at: added_struct_1.created_at.utc.iso8601
            }
          },
          {
            type: 'add',
            id: added_struct_2.id,
            fields: {
              content: added_struct_2.content,
              created_at: added_struct_2.created_at.utc.iso8601
            }
          },
          {
            type: 'delete',
            id: deleted_struct_1.id
          }
        ].to_json,
        content_type: 'application/json'
      )

      subject
    end
  end

  describe '#search' do
    let(:result) do
      clazz.search.query_parser('structured').query('matchall').execute
    end
    let(:fake_response) do
      double(
        data: {
          hits: {
            hit: [
              {
                fields: {
                  'id' => ['1'],
                  'name' => ['Michael'],
                  'tags' => ['one', 'two', 'three']
                }
              },
              {
                fields: {
                  'id' => ['2'],
                  'name' => ['Florence'],
                  'tags' => ['four', 'five']
                }
              }
            ]
          }
        },
        facets: facets
      )
    end
    let(:facets) do
      {
        'tags' => {
          'buckets' => [
            {
              'value' => 'one',
              'count' => 1
            },
            {
              'value' => 'two',
              'count' => 1
            },
            {
              'value' => 'three',
              'count' => 1
            },
            {
              'value' => 'four',
              'count' => 1
            },
            {
              'value' => 'five',
              'count' => 1
            }
          ]
        }
      }
    end

    before do
      allow(data_accessor).to receive(:field_types).and_return(
        'id' => 'int',
        'name' => 'text',
        'tags' => 'literal-array'
      )
      allow_any_instance_of(Nazrin::SearchClient).to receive(:search).and_return(
        fake_response
      )
    end

    it { expect(result.length).to eq(2) }
    it do
      expect(result[0].attributes).to eq(
        'id' => '1',
        'name' => 'Michael',
        'tags' => ['one', 'two', 'three']
      )
    end
    it do
      expect(result[1].attributes).to eq(
        'id' => '2',
        'name' => 'Florence',
        'tags' => ['four', 'five']
      )
    end
    it { expect(result.facets).to eq(facets) }
  end
end
