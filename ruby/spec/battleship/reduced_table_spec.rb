require 'spec_helper'

describe Battleship::ReducedTable do
  describe '#best_targets' do
    it 'should return points of the best targets' do
      abs_freqs = [[0,0,0], [2,0,1], [0,2,0]]
      num_total_configurations = 5

      table = Battleship::ReducedTable.new(abs_freqs, num_total_configurations)

      expect(table.best_targets.any? {|point| point.has_coords?(2,1)}).to eq true
      expect(table.best_targets.any? {|point| point.has_coords?(3,2)}).to eq true
      expect(table.num_total_configurations).to eq 5
      expect(table.point_at(2,1).abs_freq).to eq 2
    end
  end
end
