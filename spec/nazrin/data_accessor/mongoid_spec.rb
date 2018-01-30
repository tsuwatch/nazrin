require 'spec_helper'

describe Nazrin::DataAccessor::Mongoid do
  let!(:user) { User.create(email: 'example@example.com', created_at: Time.now) }

  it { expect(User).to be_respond_to :search }

  describe '#search' do
    let(:response) { FakeResponse.new(user._id.to_s) }

    before do
      allow_any_instance_of(Nazrin::SearchClient).to receive(:search).and_return(response)
    end

    context 'without facets' do
      it { expect(User.search.size(1).start(0).execute).to eq [user] }
      it { expect(User.search.size(1).start(0).execute.facets).to be_nil }
    end

    context 'with facets' do
      let(:response) { FakeResponseWithFacets.new(user._id.to_s) }
      it { expect(User.search.size(1).start(0).execute).to eq [user] }
      it { expect(User.search.size(1).start(0).execute.facets).to eq(response.facets) }
    end
  end
end
