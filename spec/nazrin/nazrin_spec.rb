require 'spec_helper'

describe Nazrin do
  describe 'configure' do
    let(:config) { Nazrin.config }
    it { expect(config.debug_mode).to be false }
    it { expect(config.mode).to eq 'sandbox' }
    it { expect(config.search_endpoint).to eq 'http://search.com' }
    it { expect(config.document_endpoint).to eq 'http://document.com' }
    it { expect(config.region).to eq :region }
    it { expect(config.access_key_id).to eq :access_key_id }
    it { expect(config.secret_access_key).to eq :secret_access_key }
  end
end
