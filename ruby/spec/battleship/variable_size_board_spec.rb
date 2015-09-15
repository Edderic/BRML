require 'spec_helper'

describe Battleship::VariableSizeBoard do
  describe '#best_targets' do
    it 'should give us [[0,0,0], [2,0,1], [0,2,0]]' do
      ship_1 = Battleship::Ship.new(length: 2)
      ship_2 = Battleship::Ship.new(length: 2)
      hit_1 = Battleship::Point.new(row: 1, col: 1)
      hit_2 = Battleship::Point.new(row: 2, col: 2)
      sink_point = Battleship::Point.new(row: 1, col: 2)
      ships = [ship_1, ship_2]
      hits = [hit_1, hit_2]
      sink_pair = Battleship::SinkPair.new(point: sink_point,
                                           ship_length: 2)
      sink_pairs = [sink_pair]
      variable_size_board = Battleship::VariableSizeBoard.new(ships: ships,
                                                         hits: hits,
                                                         sink_pairs: sink_pairs,
                                                         row_length: 3,
                                                         col_length: 3)
      abs_freqs = variable_size_board.abs_freqs
      rel_freqs = variable_size_board.rel_freqs

      expect(abs_freqs).to eq [[0,0,0], [2,0,1], [0,2,0]]
      expect(rel_freqs).to eq [[0,0,0], [0.4,0,0.2], [0,0.4,0]]
      expect(variable_size_board.num_total_configurations).to eq 5
      expect(variable_size_board.best_targets.count).to eq 2
      expect(variable_size_board.best_targets.any? do |pt|
        pt.has_coords?(2,1)
      end).to eq true

      expect(variable_size_board.best_targets.any? do |pt|
        pt.has_coords?(3,2)
      end).to eq true
    end
  end
end
