require_relative 'utils'

class Psychometry
  def initialize
    @num_pairs = 5
  end

  def absolute_frequencies_of_matches
    permutations.inject(init_hash) do |accum, permutation|
      accum[num_matches_in_one(permutation)] =
        accum[num_matches_in_one(permutation)] + 1
      accum
    end
  end

  def permutations
    combinations.inject([]) do |accum, combination|
      permutation?(combination) ? (accum << combination) : accum
    end
  end

  private

  def num_matches
    permutations.inject(0) do |accum, permutation|
      accum += num_matches_in_one(permutation)
    end
  end

  def num_matches_in_one(permutation)
    (0..@num_pairs-1).inject(0) do |accum_2, index|
      if permutation[index] == characters[index]
        accum_2 += 1
      else
        accum_2
      end
    end
  end

  def init_hash
    (0..@num_pairs).inject([]) { |accum, val| accum << 0 }
  end

  def combinations
    Utils.new(characters).combine(characters, @num_pairs)
  end

  def permutation?(combination)
    combination.uniq.length == combination.length
  end

  def characters
    ('A'..'Z').to_a[0..@num_pairs-1]
  end
end
