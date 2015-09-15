require 'spec_helper'

describe Battleship::Point do
  describe '#has_coords?(row,col)' do
    it 'should return true if has coordinates' do
      starting_point = Battleship::Point.new(row: 2, col: 2)
      expect(starting_point.has_coords?(2,2)).to eq true
      expect(starting_point.has_coords?(3,2)).to eq false
    end
  end

  describe '#neighboring_points' do
    it 'should return the neighboring points in the table' do
      ships = []
      table = Battleship::Table.new(col_length: 10,
                                    row_length: 10,
                                    ships: ships)
      starting_point = Battleship::Point.new(row: 2, col: 2)
      starting_point.table = table

      def has_neighbor(point, row,col)
        neighbors = point.neighboring_points
        has_the_neigbor = neighbors.any? {|point| point.same_as?(Battleship::Point.new(row: row, col: col))}

        expect(has_the_neigbor).to eq true
      end

      has_neighbor(starting_point, 2,1)
      has_neighbor(starting_point, 2,3)
      has_neighbor(starting_point, 1,2)
      has_neighbor(starting_point, 3,2)
    end
  end

  describe '#on_an_unsunk_ship?' do
    it 'returns true if the point is on an unsunk ship' do
      starting_point = Battleship::Point.new(row: 2, col: 2)
      ship = Battleship::HorizontalShip.new(length: 3)
      hit_1 = Battleship::Point.new(row:2, col:2)
      hits = [hit_1]
      ships = [ship]
      table = Battleship::Table.new(col_length: 10,
                                    row_length: 10,
                                    hits: hits,
                                    ships: ships)
      point = table.point_at(2,2)

      ship.start_at(starting_point)

      expect(point).to be_on_an_unsunk_ship
    end
  end

  describe '#on_a_ship?' do
    it 'returns true if the point is on a ship' do
      starting_point = Battleship::Point.new(row: 2, col: 2)
      ship = Battleship::HorizontalShip.new(length: 3)
      ships = [ship]
      table = Battleship::Table.new(col_length: 10, row_length: 10, ships: ships)
      point = table.point_at(2,2)
      ship.start_at(starting_point)

      expect(point).to be_on_a_ship
    end

    it 'returns false if the point is not on a ship' do
      starting_point = Battleship::Point.new(row: 2, col: 3)
      ship = Battleship::HorizontalShip.new(starting_point: starting_point, length: 3)
      ships = [ship]
      table = Battleship::Table.new(col_length: 10, row_length: 10, ships: ships)
      point = table.point_at(2,2)

      expect(point).not_to be_on_a_ship
    end
  end

  describe '#sink!' do
    it 'sinks the point' do
      point = Battleship::Point.new(row: 2, col: 3)
      point.sink!

      expect(point).to be_sunk
    end
  end

  describe '#off_table?' do
    it 'returns true when off the table' do
      table = instance_double('Battleship::Table', row_length: 5, col_length: 5)
      bp = Battleship::Point.new(row: 8, col: 2, table: table)

      expect(bp).to be_off_table
    end
  end

  describe '#to_s' do
    it 'returns (row, col)' do
      bp = Battleship::Point.new(row: 1, col: 2)
      expect(bp.to_s).to eq "(1,2 | u | 0)"
    end
  end

  describe '#row' do
    it 'should return the row' do
      bp = Battleship::Point.new(row: 1, col: 2)
      expect(bp.row).to eq 1
    end
  end

  describe '#col' do
    it 'should return the col' do
      bp = Battleship::Point.new(row: 1, col: 2)
      expect(bp.col).to eq 2
    end
  end

  describe '#miss!' do
    it 'sets the state of the point to :miss' do
      bp = Battleship::Point.new(row: 1, col: 2)
      bp.miss!

      expect(bp).to be_missed
    end
  end

  describe '#same_as?(point)' do
    it 'should be true if point has the same coordinates as the given point' do
      bp = Battleship::Point.new(row: 1, col: 2)
      expect(bp.same_as?(bp)).to eq true
    end
  end

  describe '#hit!' do
    it 'sets the state of the point to :hit' do
      bp = Battleship::Point.new(row: 1, col: 2)
      bp.hit!

      expect(bp).to be_hit
    end
  end

  it 'should be untried at first' do
    bp = Battleship::Point.new(row: 1, col: 2)
    expect(bp).to be_untried
  end

  it 'can be initialized to being missed' do
    bp = Battleship::Point.new(row: 1, col: 2, state: :missed)
    expect(bp).to be_missed
  end
end
