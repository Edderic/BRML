class Utils
  def initialize(num_pairs)
    @num_pairs = num_pairs
  end

  def combinations(num_iteration)
    combine(characters, num_iteration)
  end

  def combine(accum, num_iteration)
    return accum if num_iteration <= 1

    new_accum = characters.inject([]) do |accum_1, char|
      accum_1 | accum.map do |item|
        [char, item].flatten
      end
    end

    combine(new_accum, num_iteration - 1)
  end

  def characters
    ('A'..'Z').to_a[0..@num_pairs-1]
  end
end
