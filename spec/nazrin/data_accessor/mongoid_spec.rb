require 'spec_helper'

describe Nazrin::DataAccessor::Mongoid do
  let!(:user) { User.create(email: 'example@example.com', created_at: Time.now) }

  it { expect(User).to be_respond_to :search }

  describe '#search' do
    before do
      allow_any_instance_of(Nazrin::SearchClient).to receive(:search).and_return(FakeResponse.new(user._id.to_s))
    end

    it { expect(User.search.size(1).start(0).execute).to eq [user] }
  end
end
