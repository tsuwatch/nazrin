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
        }
      )
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
  end
end
