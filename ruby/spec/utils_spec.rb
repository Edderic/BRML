require 'spec_helper'

describe Utils do
  describe '#combinations' do
    it 'should return the right amount of items' do
      num_items_to_choose_from = 4
      num_times_to_combine = 7
      utils = Utils.new(num_items_to_choose_from)
      combinations = utils.combinations(num_times_to_combine)
      expect(combinations.count).to eq 16384
      expect(combinations).to include(['A', 'A', 'A', 'A', 'A', 'A', 'A'])
    end
  end
end
