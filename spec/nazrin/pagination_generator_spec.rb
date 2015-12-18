require 'spec_helper'

describe Nazrin::PaginationGenerator do
  describe 'generate' do
    let(:paginated_array) do
      described_class.generate(
        [1, 2, 3],
        current_page: 1, per_page: 1, total_count: 3)
    end

    context 'kaminari' do
      before { Nazrin.config.pagination = 'kaminari' }
      it { expect(paginated_array.class).to eq Kaminari::PaginatableArray }
      it { expect(paginated_array.current_page).to eq 1 }
      it { expect(paginated_array.total_pages).to eq 3 }
    end

    context 'will_paginate' do
      before { Nazrin.config.pagination = 'will_paginate' }
      it { expect(paginated_array.class).to eq WillPaginate::Collection }
      it { expect(paginated_array.current_page).to eq 1 }
      it { expect(paginated_array.total_pages).to eq 3 }
    end

    context 'nazrin' do
      before { Nazrin.config.pagination = 'nazrin' }
      it { expect(paginated_array.class).to eq Nazrin::PaginatedArray }
      it { expect(paginated_array.current_page).to eq 1 }
      it { expect(paginated_array.total_pages).to eq 3 }
    end
  end
end
