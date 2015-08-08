require 'spec_helper'

describe Pizza4U do
  describe '#unique_combinations' do
    it 'should not return any duplicates' do
      pizza_4_u = Pizza4U.new
      uniq_combs = pizza_4_u.unique_combinations

      orig = ['A', 'A', 'A', 'A', 'A', 'A', 'B']
      rearranged_1 = ['A', 'A', 'A', 'A', 'A', 'B', 'A']
      rearranged_2 = ['A', 'B', 'A', 'A', 'A', 'A', 'A']

      expect(uniq_combs).to include(orig)
      expect(uniq_combs).not_to include(rearranged_1)
      expect(uniq_combs.count).to eq 120
    end
  end
end
