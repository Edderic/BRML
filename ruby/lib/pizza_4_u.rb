require 'utils'

class Pizza4U
  attr_reader :combinations, :unique_combinations, :combinations_size, :unique_absolute_freqs

  def initialize
    @utils = Utils.new(4)
    @combinations = @utils.combinations(7)
    @unique_combinations = combinations.map {|combination| combination.sort}.uniq

    @combinations_size = combinations.count
    @unique_absolute_freqs = unique_combinations.inject({}) do |accum, uniq_combo|
      accum[uniq_combo.join] = combinations.select{|combination| same_unique_combo(combination, uniq_combo)}.count
      accum
    end
  end

  def accuracy(num_times)
    score(num_times) / num_times.to_f
  end

  def prob_correct
    corrects_of_joint_distribution.inject(0) do |accum, hash|
      accum = accum + hash[:posterior_prob]
      accum
    end
  end

  private

  def corrects_of_joint_distribution
    joint_distribution.select{|item| item[:correct] == true}
  end

  def joint_distribution
    unique_absolute_freqs.inject([]) do |accum_1, (chef_k,chef_v)|
      accum_1 + unique_absolute_freqs.inject([]) do |accum_2, (customers_k,customers_v)|

      posterior_prob = chef_v / combinations_size.to_f * customers_v / combinations_size.to_f
      hash = { correct: false, posterior_prob: posterior_prob}

      if chef_k == customers_k
        hash[:correct] = true
      end

      accum_2 << hash
    end
    end
  end

  def score(num_times)
    r = Random.new

    (0..num_times-1).inject(0) do |accum, count|
      customers_pick = pick(r)
      chefs_pick = pick(r)

      if same_unique_combo(customers_pick, chefs_pick)
        accum = accum + 1
      else
        accum
      end
    end
  end

  def same_unique_combo(pick1, pick2)
    pick1.sort == pick2.sort
  end

  def pick(r)
    pick_index = r.rand * combinations.length - 1
    combinations[pick_index]
  end
end
