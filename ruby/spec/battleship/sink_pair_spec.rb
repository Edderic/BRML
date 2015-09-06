require 'spec_helper'

describe Battleship::SinkPair do
  describe '#ambiguous?' do
    describe 'when the associated ship can cover the sink point more than one way' do
      it 'should return true' do
        sink_point = Battleship::Point.new(row: 1, col: 1)
        hit_point_1 = Battleship::Point.new(row: 1, col: 2)
        hit_point_2 = Battleship::Point.new(row: 2, col: 1)
        hits = [hit_point_1, hit_point_2]
        unsink_ship = Battleship::Ship.new(length: 2)
        ships = [unsink_ship]
        sink_pair = Battleship::SinkPair.new(point: sink_point, ship_length: 2)
        sink_pairs = [sink_pair]
        tables_generator = Battleship::TablesGenerator.new(row_length: 3,
                                                         col_length: 3,
                                                         sink_pairs: sink_pairs,
                                                         hits: hits,
                                                         ships: ships
                                                          )
        expect(sink_pair).to be_ambiguous
      end
    end

    describe 'when the associated ship has only one way to cover the sink point' do
      it 'should return false' do
        sink_point = Battleship::Point.new(row: 1, col: 1)
        hit_point_1 = Battleship::Point.new(row: 1, col: 2)
        hit_points = [hit_point_1]
        unsink_ship = Battleship::Ship.new(length: 2)
        ships = [unsink_ship]
        sink_pair = Battleship::SinkPair.new(point: sink_point, ship_length: 2)
        sink_pairs = [sink_pair]
        tables_generator = Battleship::TablesGenerator.new(row_length: 3,
                                                         col_length: 3,
                                                         sink_pairs: sink_pairs,
                                                         hit_points: hit_points,
                                                         ships: ships
                                                          )
        expect(sink_pair).not_to be_ambiguous
      end
    end
  end
end
