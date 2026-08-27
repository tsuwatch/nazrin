require 'spec_helper'

describe Nazrin::DocumentClient do
  let(:document_client) { described_class.new }
  it { expect(document_client).to be_respond_to :client }
  it { expect(document_client.client.class).to eq Aws::CloudSearchDomain::Client }

  context 'config.mode = \'sandbox\'' do
    before { Nazrin.config.mode = 'sandbox' }
    it { expect(document_client.add_document(1, {})).to eq nil }
    it { expect(document_client.delete_document(1)).to eq nil }
  end

  context 'with logger configured' do
    let(:logger) { instance_double(Logger) }
    before { Nazrin.config.logger = logger }
    after { Nazrin.config.logger = nil }
    it 'sets the client logger' do
      expect(document_client.client.config.logger).to eq(logger)
    end
  end
end
