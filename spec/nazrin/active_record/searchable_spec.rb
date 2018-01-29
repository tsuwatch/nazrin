require 'spec_helper'

describe Nazrin::Searchable do
  let!(:post) { Post.create(content: 'content', created_at: Time.now) }

  it { expect(Post).to be_respond_to :search }
  it { expect(Post).to be_respond_to :fields }
  it { expect(Post).to be_respond_to :field }
  it { expect(post).to be_respond_to :add_to_index }
  it { expect(post).to be_respond_to :update_in_index }
  it { expect(post).to be_respond_to :delete_from_index }

  describe '#search' do
    let(:response) { FakeResponse.new }
    before { allow_any_instance_of(Nazrin::SearchClient).to receive(:search).and_return(response) }

    it { expect(Post.search.is_a?(Nazrin::SearchClient)).to eq true }
    it { expect(Post.search.data_accessor.is_a?(Nazrin::DataAccessor::ActiveRecord)).to eq true }

    context 'without facets' do
      it { expect(Post.search.size(1).start(0).execute).to eq [post] }
      it { expect(Post.search.size(1).start(0).execute.facets).to be_nil }
    end

    context 'with facets' do
      let(:response) { FakeResponseWithFacets.new }
      it { expect(Post.search.size(1).start(0).execute).to eq [post] }
      it { expect(Post.search.size(1).start(0).execute.facets).to eq(response.facets) }
    end
  end

  describe '#search_configure' do
    before do
      allow_any_instance_of(Nazrin::SearchClient).to receive(:search).and_return(FakeResponse.new)
      Post.class_eval do
        searchable_configure do |config|
          config.search_endpoint = 'http://override-search.com'
          config.document_endpoint = 'http://override-document.com'
        end
      end
    end

    after { Post.instance_variable_set('@nazrin_searchable_config', nil) }

    it 'overrides Post search endpoint' do
      expect(Aws::CloudSearchDomain::Client).to receive(:new).with(hash_including({endpoint: 'http://override-search.com'}))
      Post.search
    end

    it 'does not override User search endpoint' do
      expect(Aws::CloudSearchDomain::Client).to receive(:new).with(hash_including({endpoint: 'http://search.com'}))
      User.search
    end

  end
end
