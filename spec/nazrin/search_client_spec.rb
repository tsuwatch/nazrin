require 'spec_helper'

describe Nazrin::SearchClient do
  let(:search_client) { described_class.new }
  it { expect(search_client).to be_respond_to :parameters }
  it { expect(search_client).to be_respond_to :data_accessor }

  describe '#execute' do
    before { allow_any_instance_of(Nazrin::SearchClient).to receive(:search).and_return(FakeResponse.new) }

    it { expect(search_client.execute.is_a?(FakeResponse)).to eq true }
  end
end
