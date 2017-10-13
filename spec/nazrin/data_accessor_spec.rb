require 'spec_helper'

describe Nazrin::DataAccessor do
  describe 'register_accessor' do
    it { expect(described_class.register_accessor(Post)).to eq(Nazrin::DataAccessor::ActiveRecord) }
    it { expect(described_class.register_accessor(Hash)).to be_nil }
  end
end
