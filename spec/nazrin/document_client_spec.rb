require 'spec_helper'

describe Nazrin::DocumentClient do
  let(:document_client) { described_class.new }
  it { expect(document_client).to be_respond_to :client }
  it { expect(document_client.client.class).to eq Aws::CloudSearchDomain::Client }
end
