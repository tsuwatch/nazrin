require 'spec_helper'

describe Nazrin::PaginatedArray do
  let(:paginated_array) do
    described_class.new(
      [1, 2, 3], 1, 1, 3)
  end

  it { expect(paginated_array.first_page?).to eq true }
  it { expect(paginated_array.last_page?).to eq false }
  it { expect(paginated_array.total_pages).to eq 3 }
  it { expect(paginated_array.previous_page).to eq nil }
  it { expect(paginated_array.next_page).to eq 2 }
  it { expect(paginated_array.out_of_bounds?).to eq false }
end
