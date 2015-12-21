require 'spec_helper'

describe Nazrin::SearchClient do
  let(:search_client) { described_class.new }

  before { allow_any_instance_of(Aws::CloudSearchDomain::Client).to receive(:search).and_return(FakeResponse.new) }

  it { expect(search_client).to be_respond_to :parameters }
  it { expect(search_client).to be_respond_to :data_accessor }

  describe '#execute' do
    it { expect(search_client.execute.is_a?(FakeResponse)).to eq true }
  end

  describe '#search' do
    context 'no start and size' do
      it { expect(search_client.search.is_a?(FakeResponse)).to eq true }
    end

    context 'start at 10_001' do
      before { search_client.start(10_001) }

      it { expect { search_client.search }.to raise_error(Nazrin::SearchClientError) }
    end

    context '10_001 size' do
      before { search_client.size(10_001) }

      it { expect { search_client.search }.to raise_error(Nazrin::SearchClientError) }
    end

    context 'start + size > 10_000' do
      before do
        search_client.start(5001)
        search_client.size(5000)
      end

      it { expect { search_client.search }.to raise_error(Nazrin::SearchClientError) }
    end

    context 'start + size < 10_000' do
      before do
        search_client.start(5)
        search_client.size(5)
      end

      it { expect(search_client.search.is_a?(FakeResponse)).to eq true }
    end

    context 'start < 10_000' do
      before do
        search_client.start(5)
      end

      it { expect(search_client.search.is_a?(FakeResponse)).to eq true }
    end

    context 'size < 10_000' do
      before do
        search_client.size(5)
      end

      it { expect(search_client.search.is_a?(FakeResponse)).to eq true }
    end
  end
end
