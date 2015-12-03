require 'spec_helper'

describe Nazrin do
  describe 'configure' do
    let(:config) { Nazrin.config }
    it { expect(config.debug_mode).to be false }
    it { expect(config.search_endpoint).to eq 'http://search' }
    it { expect(config.document_endpoint).to eq 'http://document' }
    it { expect(config.region).to eq :region }
    it { expect(config.access_key_id).to eq :access_key_id }
    it { expect(config.secret_access_key).to eq :secret_access_key }
    it { expect(config.pagination).to eq 'kaminari' }
  end

  describe 'paginated_array' do
    let(:paginated_array) do
      Nazrin.paginated_array(
        [1, 2, 3],
        current_page: 1, per_page: 1, total_count: 3)
    end

    context 'kaminari' do
      before { Nazrin.config.pagination = 'kaminari' }
      it { expect(paginated_array.class).to eq Kaminari::PaginatableArray }
    end

    context 'nazrin' do
      before { Nazrin.config.pagination = 'nazrin' }
      it { expect(paginated_array.class).to eq Nazrin::PaginatedArray }
      it { expect(paginated_array.first_page?).to eq true }
      it { expect(paginated_array.last_page?).to eq false }
      it { expect(paginated_array.total_pages).to eq 3 }
      it { expect(paginated_array.previous_page).to eq nil }
      it { expect(paginated_array.next_page).to eq 2 }
      it { expect(paginated_array.out_of_bounds?).to eq false }
    end
  end
end
