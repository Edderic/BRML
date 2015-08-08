require 'utils'

class Pizza4U
  def initialize
    @utils = Utils.new(4)
  end

  def unique_combinations
    combinations.map {|combination| combination.sort}.uniq
  end

  private

  def combinations
    @utils.combinations(7)
  end
end
