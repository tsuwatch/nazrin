require 'spec_helper'

describe Nazrin::ActiveRecord::Searchable do
  let!(:post) { Post.create(content: 'content', created_at: Time.now) }

  it { expect(Post).to be_respond_to :search }
  it { expect(Post).to be_respond_to :fields }
  it { expect(Post).to be_respond_to :field }
  it { expect(post).to be_respond_to :add_to_index }
  it { expect(post).to be_respond_to :update_in_index }
  it { expect(post).to be_respond_to :delete_from_index }

  describe '#search' do
    before { allow_any_instance_of(Nazrin::SearchClient).to receive(:search).and_return(FakeResponse.new) }

    it { expect(Post.search.is_a?(Nazrin::SearchClient)).to eq true }
    it { expect(Post.search.data_accessor.is_a?(Nazrin::ActiveRecord::DataAccessor)).to eq true }

    it { expect(Post.search.size(1).start(0).execute).to eq [post] }
  end
end
