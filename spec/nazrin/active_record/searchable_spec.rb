require 'spec_helper'

describe Nazrin::Searchable do
  let!(:post) { Post.create(content: 'content', created_at: Time.now) }

  it { expect(Post).to be_respond_to :search }
  it { expect(Post).to be_respond_to :fields }
  it { expect(Post).to be_respond_to :field }
  it { expect(post).to be_respond_to :add_to_index }
  it { expect(post).to be_respond_to :update_in_index }
  it { expect(post).to be_respond_to :delete_from_index }

  describe '.nazrin_batch_operation' do
    let!(:other_post) { Post.create(content: 'other', created_at: Time.now) }
    let!(:deleted_post) { Post.create(content: 'deleted', created_at: Time.now) }
    let(:domain_client) do
      instance_double(Aws::CloudSearchDomain::Client)
    end

    before do
      allow(Aws::CloudSearchDomain::Client).to receive(:new)
        .and_return(domain_client)
      allow(domain_client).to receive(:upload_documents)

      # Hacky method to reset CS domain client
      Post.class_eval do
        searchable  do
          fields [:content]
          field(:created_at) { created_at.utc.iso8601 }
        end
      end
    end

    subject do
      Post.nazrin_batch_operation(
        add: [post, other_post],
        delete: [deleted_post]
      )
    end

    it do
      expect(domain_client).to receive(:upload_documents).with(
        documents: [
          {
            type: 'add',
            id: post.id,
            fields: {
              content: post.content,
              created_at: post.created_at.utc.iso8601
            }
          },
          {
            type: 'add',
            id: other_post.id,
            fields: {
              content: other_post.content,
              created_at: other_post.created_at.utc.iso8601
            }
          },
          {
            type: 'delete',
            id: deleted_post.id
          }
        ].to_json,
        content_type: 'application/json'
      )

      subject
    end
  end

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
