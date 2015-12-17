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
    end

    context 'nazrin' do
      before { Nazrin.config.pagination = 'nazrin' }
      it { expect(paginated_array.class).to eq Nazrin::PaginatedArray }
    end
  end
end
