require 'spec_helper'

describe Pizza4U do
  describe '#unique_combinations' do
    it 'should not return any duplicates' do
      pizza_4_u = Pizza4U.new
      uniq_combs = pizza_4_u.unique_combinations

      orig = ['A', 'A', 'A', 'A', 'A', 'A', 'B']
      rearranged_1 = ['A', 'A', 'A', 'A', 'A', 'B', 'A']
      rearranged_2 = ['A', 'B', 'A', 'A', 'A', 'A', 'A']

      orig_1 = ['A', 'A', 'A', 'A', 'A', 'B', 'B']
      rearranged_3 = ['A', 'B', 'A', 'B', 'A', 'A', 'A']
      rearranged_4 = ['B', 'B', 'A', 'A', 'A', 'A', 'A']

      orig_2 = [ 'B', 'B', 'D', 'D', 'D', 'D', 'D']

      # should not be included because there are only four
      # pizzas to choose from, not 5.
      orig_3 = [ 'E','E','E','E','E','E','E' ]


      expect(uniq_combs).to include(orig)
      expect(uniq_combs).to include(orig_1)
      expect(uniq_combs).to include(orig_2)
      expect(uniq_combs).not_to include(orig_3)
      expect(uniq_combs).not_to include(rearranged_1)
      expect(uniq_combs).not_to include(rearranged_2)
      expect(uniq_combs).not_to include(rearranged_3)
      expect(uniq_combs).not_to include(rearranged_4)
      expect(uniq_combs.count).to eq 120
    end
  end

  describe '#accuracy(num_times)' do
    it 'picks a random combination of pizzas (ordered by people) and compares it with another randomly-picked combination of pizzas (picked by the chef) and gives us a score' do
      pizza_4_u = Pizza4U.new
      accuracy = pizza_4_u.accuracy(1000000)

      expect(accuracy.round(3)).to eq 0.018
    end
  end

  describe '#unique_absolute_freqs' do
    it 'should return a dictionary with unique combinations as keys and absolute freqs as values' do

      pizza_4_u = Pizza4U.new
      unique_absolute_freqs = pizza_4_u.unique_absolute_freqs

      total_count =  unique_absolute_freqs.inject(0){|accum,(k,v)| accum = accum + v; accum}
      expect(total_count).to eq 16384
      expect(unique_absolute_freqs['AAAAAAA']).to be 1
      expect(unique_absolute_freqs['AAAAAAB']).to be 7
    end
  end

  describe '#prob_correct' do
    it 'gives us the chance that the chef was correct' do
      pizza_4_u = Pizza4U.new
      expect(pizza_4_u.prob_correct.round(3)).to eq 0.018383.round(3)
    end
  end
end
