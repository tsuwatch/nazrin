require 'spec_helper'

describe 'Nazrin::Searchable with a custom primary key' do
  let!(:article) do
    Article.create(slug: 'first-article', content: 'content', created_at: Time.now)
  end
  let(:domain_client) { instance_double(Aws::CloudSearchDomain::Client) }

  before do
    allow(Aws::CloudSearchDomain::Client).to receive(:new).and_return(domain_client)
    allow(domain_client).to receive(:upload_documents)

    # Hacky method to reset CS domain client
    Article.class_eval do
      searchable(:slug) do
        fields [:content]
        field(:created_at) { created_at.utc.iso8601 }
      end
    end
  end

  describe '.nazrin_doc_id' do
    it { expect(Article.nazrin_doc_id).to eq :slug }
  end

  describe '#add_to_index' do
    it 'uses the custom key as the document id' do
      expect(domain_client).to receive(:upload_documents).with(
        documents: [
          {
            type: 'add',
            id: article.slug,
            fields: {
              content: article.content,
              created_at: article.created_at.utc.iso8601
            }
          }
        ].to_json,
        content_type: 'application/json'
      )

      article.add_to_index
    end
  end

  describe '#delete_from_index' do
    it 'uses the custom key as the document id' do
      expect(domain_client).to receive(:upload_documents).with(
        documents: [
          {
            type: 'delete',
            id: article.slug
          }
        ].to_json,
        content_type: 'application/json'
      )

      article.delete_from_index
    end
  end

  describe '.nazrin_batch_operation' do
    let!(:other_article) do
      Article.create(slug: 'second-article', content: 'other', created_at: Time.now)
    end
    let!(:deleted_article) do
      Article.create(slug: 'third-article', content: 'deleted', created_at: Time.now)
    end

    it 'uses the custom key as the document id for each operation' do
      expect(domain_client).to receive(:upload_documents).with(
        documents: [
          {
            type: 'add',
            id: article.slug,
            fields: {
              content: article.content,
              created_at: article.created_at.utc.iso8601
            }
          },
          {
            type: 'add',
            id: other_article.slug,
            fields: {
              content: other_article.content,
              created_at: other_article.created_at.utc.iso8601
            }
          },
          {
            type: 'delete',
            id: deleted_article.slug
          }
        ].to_json,
        content_type: 'application/json'
      )

      Article.nazrin_batch_operation(
        add: [article, other_article],
        delete: [deleted_article]
      )
    end
  end

  describe '#search' do
    let(:response) { FakeResponse.new(article.slug) }

    before do
      allow_any_instance_of(Nazrin::SearchClient)
        .to receive(:search).and_return(response)
    end

    it 'loads records looked up by the custom key' do
      expect(Article.search.size(1).start(0).execute).to eq [article]
    end
  end
end
