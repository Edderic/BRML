require 'spec_helper'

describe Battleship::Ship do
  before do
    @starting_point = Battleship::Point.new(row: 1, col: 1)
    @table = Battleship::Table.new(row_length: 5,
                                   col_length: 5,
                                   ships: [])
  end

  describe '#occupied_points_unique?' do
    describe 'when occupied points are unique' do
      it 'should return true' do
        ship_1 = Battleship::HorizontalShip.new(length: 2)
        ship_2 = Battleship::HorizontalShip.new(length: 2)
        hit_1 = Battleship::Point.new(row: 1, col: 1)
        hit_2 = Battleship::Point.new(row: 2, col: 2)
        ships = [ship_1, ship_2]
        hits = [hit_1, hit_2]
        table = Battleship::Table.new(ships: ships,
                                      hits: hits,
                                      sink_pairs: [],
                                      row_length: 3,
                                      col_length: 3)
        ship_1.start_at(Battleship::Point.new(row: 1, col:1))
        ship_2.start_at(Battleship::Point.new(row: 2, col:1))

        expect(ship_1).to be_occupied_points_unique
        expect(ship_2).to be_occupied_points_unique
      end
    end
  end

  describe '#fully_sunk?' do
    it 'should return true when the ship is fully sunk' do
      ship_1 = Battleship::HorizontalShip.new(length: 3)
      ship_2 = Battleship::HorizontalShip.new(length: 2)
      hit_1_5 = Battleship::Point.new(row: 1, col: 5)
      hit_1_7 = Battleship::Point.new(row: 1, col: 7)
      sink_1_6 = Battleship::Point.new(row: 1, col: 6)
      sink_pair = Battleship::SinkPair.new(point: sink_1_6,
                                           ship_length: 3)
      sink_pairs = [sink_pair]
      ships = [ship_1, ship_2]
      hits = [hit_1_5, hit_1_7]
      table = Battleship::Table.new(col_length: 10,
                                    row_length: 1,
                                    ships: ships,
                                    hits: hits,
                                    sink_pairs: sink_pairs)
      sink_pair.sink!

      expect(ship_1).to be_fully_sunk
      expect(ship_2).not_to be_fully_sunk
    end

    it 'should return false when the ship is not fully sunk' do
      ship_1 = Battleship::HorizontalShip.new(length: 3)
      ship_2 = Battleship::HorizontalShip.new(length: 2)
      hit_1_5 = Battleship::Point.new(row: 1, col: 5)
      hit_1_7 = Battleship::Point.new(row: 1, col: 7)
      sink_1_6 = Battleship::Point.new(row: 1, col: 6)
      sink_pair = Battleship::SinkPair.new(point: sink_1_6,
                                           ship_length: 2)
      sink_pairs = [sink_pair]
      ships = [ship_1, ship_2]
      hits = [hit_1_5, hit_1_7]
      table = Battleship::Table.new(col_length: 10,
                                    row_length: 1,
                                    ships: ships,
                                    hits: hits,
                                    sink_pairs: sink_pairs)
      sink_pair.sink!
      expect(ship_1).not_to be_fully_sunk
      expect(ship_2).not_to be_fully_sunk
    end

    it 'should return false even when no sinking has been attempted' do
    end
  end

  describe '#ambiguous_sunk?' do
    it 'by default should be false' do
      ship_1 = Battleship::HorizontalShip.new(length: 3)
      ship_2 = Battleship::HorizontalShip.new(length: 2)
      hit_1_5 = Battleship::Point.new(row: 1, col: 5)
      hit_1_7 = Battleship::Point.new(row: 1, col: 7)
      sink_1_6 = Battleship::Point.new(row: 1, col: 6)
      sink_pair = Battleship::SinkPair.new(point: sink_1_6,
                                           ship_length: 2)
      sink_pairs = [sink_pair]
      ships = [ship_1, ship_2]
      hits = [hit_1_5, hit_1_7]
      table = Battleship::Table.new(col_length: 10,
                                    row_length: 1,
                                    ships: ships,
                                    hits: hits,
                                    sink_pairs: sink_pairs)
      expect(ship_1).not_to be_ambiguous_sunk
    end
  end

  describe '#start_at?(point)' do
    it 'should return true if point has same coords as starting point' do
      ship_1 = Battleship::HorizontalShip.new(length: 3)
      ship_2 = Battleship::HorizontalShip.new(length: 2)
      hit_1_5 = Battleship::Point.new(row: 1, col: 5)
      hit_1_7 = Battleship::Point.new(row: 1, col: 7)
      sink_1_6 = Battleship::Point.new(row: 1, col: 6)
      sink_pair = Battleship::SinkPair.new(point: sink_1_6,
                                           ship_length: 2)
      sink_pairs = [sink_pair]
      ships = [ship_1, ship_2]
      hits = [hit_1_5, hit_1_7]
      table = Battleship::Table.new(col_length: 10,
                                    row_length: 1,
                                    ships: ships,
                                    hits: hits,
                                    sink_pairs: sink_pairs)
      ship_1.start_at(hit_1_5)
      expect(ship_1.start_at?(hit_1_5)).to eq true
      expect(ship_1.start_at?(hit_1_7)).to eq false
    end
  end

  describe '#sunk_at?(sunk_point)' do
    describe 'when the the occupied points are all hit but the given point is sunk' do
      it 'should return true' do
        ship_1 = Battleship::HorizontalShip.new(length: 3)
        ship_2 = Battleship::HorizontalShip.new(length: 2)
        hit_1_5 = Battleship::Point.new(row: 1, col: 5)
        hit_1_7 = Battleship::Point.new(row: 1, col: 7)
        sink_1_6 = Battleship::Point.new(row: 1, col: 6)
        sink_pair = Battleship::SinkPair.new(point: sink_1_6,
                                             ship_length: 2)
        sink_pairs = [sink_pair]
        ships = [ship_1, ship_2]
        hits = [hit_1_5, hit_1_7]
        table = Battleship::Table.new(col_length: 10,
                                      row_length: 1,
                                      ships: ships,
                                      hits: hits,
                                      sink_pairs: sink_pairs)
        table.sink!(sink_pair)
        ship_1.start_at(hit_1_5)

        expect(ship_1.sunk_at?(sink_1_6)).to eq true

        ship_1.start_at(Battleship::Point.new(row: 1, col: 1))
        ship_2.start_at(sink_1_6)

        expect(ship_2.sunk_at?(sink_1_6)).to eq true
      end
    end
  end

  describe '#to_s' do
    it 'should return print out the starting point and occupied_points' do
      starting_point = Battleship::Point.new(row: 3,col: 4)

      ship_1 = Battleship::HorizontalShip.new(length: 1)
      table = Battleship::Table.new(row_length: 5,
                                    col_length: 5,
                                    hits: [],
                                    ships: [ship_1])
      ship_1.start_at(starting_point)
      ship_1.sink!(starting_point)
      expect(ship_1.to_s).to eq "sunk: true: (3,4 | s | 0)"
    end
  end

  describe '#sink!(point)' do
    describe 'when the point given is sunk and the points of interest are hit or sunk' do
      it 'should sink the ship' do
        starting_point = Battleship::Point.new(row: 1, col: 2)
        ship_1 = Battleship::HorizontalShip.new(length: 3)
        ships = [ship_1]
        hit_1 = Battleship::Point.new(row: 1, col: 2)
        hit_2 = Battleship::Point.new(row: 1, col: 3)
        hit_3 = Battleship::Point.new(row: 1, col: 4)

        hits = [hit_1, hit_2]
        table = Battleship::Table.new(row_length:1,
                                      col_length: 4,
                                      hits: hits,
                                      ships: ships)
        ship_1.start_at(starting_point)
        ship_1.sink!(hit_3)

        expect(ship_1).to be_sunk
        expect(table.point_at(hit_1)).to be_sunk
        expect(table.point_at(hit_2)).to be_sunk
        expect(table.point_at(hit_3)).to be_sunk
      end

      it 'should give the correct occupied points' do
        starting_point = Battleship::Point.new(row: 1, col: 2)
        ship_1 = Battleship::HorizontalShip.new(length: 3)
        ships = [ship_1]
        hit_1 = Battleship::Point.new(row: 1, col: 2)
        hit_2 = Battleship::Point.new(row: 1, col: 3)
        hit_3 = Battleship::Point.new(row: 1, col: 4)

        hits = [hit_1, hit_2]
        table = Battleship::Table.new(row_length:1,
                                      col_length: 4,
                                      hits: hits,
                                      ships: ships)
        ship_1.start_at(starting_point)
        ship_1.sink!(hit_3)

        occupied_points = ship_1.occupied_points
        expect(occupied_points[0].same_as?(hit_1)).to eq true
        expect(occupied_points[1].same_as?(hit_2)).to eq true
        expect(occupied_points[2].same_as?(hit_3)).to eq true
        expect(table.point_at(hit_3)).to be_sunk
      end

      it 'should set the start point' do
      end
    end

    describe 'the points of interest are not hits' do
      it 'does not sink the occupied points if not all of them are hits' do
        starting_point = Battleship::Point.new(row: 1, col: 2)
        ship_1 = Battleship::HorizontalShip.new(length: 3,
                                                starting_point: starting_point)
        ships = [ship_1]
        hit_1 = Battleship::Point.new(row: 1, col: 2)
        hit_2 = Battleship::Point.new(row: 1, col: 3)

        hits = [hit_1]
        table = Battleship::Table.new(row_length:1,
                                      col_length: 4,
                                      hits: hits,
                                      ships: ships)
        ship_1.sink!(hit_2)

        expect(ship_1).not_to be_sunk
        expect(table.point_at(hit_1)).not_to be_sunk
        expect(table.point_at(hit_2)).not_to be_sunk
      end
    end
  end

  describe 'to_horizontal' do
    it 'returns a new instance that is horizontal' do
      starting_point = Battleship::Point.new(row: 1, col: 1)
      horizontal_ship = Battleship::Ship.new(length: 3).to_horizontal
      ships = [horizontal_ship]
      table = Battleship::Table.new(row_length: 1, col_length: 10, ships: ships, misses: [])

      horizontal_ship.start_at(starting_point)
      occupied_points = horizontal_ship.occupied_points

      expect(occupied_points[0].same_as?(Battleship::Point.new(row: 1,col: 1))).to eq true
      expect(occupied_points[1].same_as?(Battleship::Point.new(row: 1,col: 2))).to eq true
      expect(occupied_points[2].same_as?(Battleship::Point.new(row: 1,col: 3))).to eq true
    end
  end


  describe 'to_vertical' do
    it 'returns a new instance that is vertical' do
      starting_point = Battleship::Point.new(row: 1, col: 1)
      vertical_ship = Battleship::Ship.new(length: 3).to_vertical
      ships = [vertical_ship]
      table = Battleship::Table.new(row_length: 1, col_length: 10, ships: ships, misses: [])
      vertical_ship.start_at(starting_point)
      occupied_points = vertical_ship.occupied_points
      expect(occupied_points[0].same_as?(Battleship::Point.new(row: 1,col: 1))).to eq true
      expect(occupied_points[1].same_as?(Battleship::Point.new(row: 2,col: 1))).to eq true
      expect(occupied_points[2].same_as?(Battleship::Point.new(row: 3,col: 1))).to eq true
    end
  end

  describe '#occupies_valid_points?' do
    it 'returns false when ship occupies points that have already been occupied' do
      point_1 = Battleship::Point.new(row: 1, col: 1)
      point_2 = Battleship::Point.new(row: 1, col: 2)
      ship_1 = Battleship::HorizontalShip.new(length: 4,
                                              starting_point: point_1)
      ship_2 = Battleship::HorizontalShip.new(length: 3,
                                              starting_point: point_2)
      ships = [ship_1, ship_2]
      table = Battleship::Table.new(row_length: 1, col_length: 10, ships: ships, misses: [])

      expect(ship_1).not_to be_occupies_valid_points
    end

    it 'returns true when ship occupies points that have already been occupied' do
      point_1 = Battleship::Point.new(row: 1, col: 1)
      point_2 = Battleship::Point.new(row: 1, col: 5)
      ship_1 = Battleship::HorizontalShip.new(length: 4)
      ship_2 = Battleship::HorizontalShip.new(length: 3)
      ships = [ship_1, ship_2]
      table = Battleship::Table.new(row_length: 1,
                                    col_length: 10,
                                    ships: ships,
                                    misses: [])

      ship_1.start_at(point_1)
      ship_2.start_at(point_2)

      expect(ship_1).to be_occupies_valid_points
    end
  end

  describe '#abs_freq!' do
    it 'does not increase the abs_freq of the hit points' do
      starting_point = Battleship::Point.new(row: 1, col: 1)
      ship = Battleship::HorizontalShip.new(length: 2)
      hits = [starting_point]
      table = Battleship::Table.new(row_length: 1,
                                    col_length: 3,
                                    ships: [ship],
                                    hits: hits)
      table.abs_freq!
      expect(table.abs_freqs.first).to eq [0,1,0]
    end
  end

  describe '#occupies?(point)' do
    it 'returns true if occupies the point' do
      horizontal_ship = Battleship::HorizontalShip.new(length: 2,
                                                       table: @table,
                                                       starting_point: @starting_point)

      expect(horizontal_ship.occupies_point?(1,1)).to eq true
      expect(horizontal_ship.occupies_point?(1,2)).to eq true
      expect(horizontal_ship.occupies_point?(1,3)).to eq false
    end
  end

  describe '#occupied_points' do
    it 'returns a list of occupied points' do
      horizontal_ship = Battleship::HorizontalShip.new(length: 2,
                                                       table: @table,
                                                       starting_point: @starting_point)

      occupied_points = horizontal_ship.occupied_points
      def has_point(some_point, occupied_points)
        occupied_points.any? {|point| point.row == some_point.row && point.col == some_point.col}
      end

      expect(has_point(Battleship::Point.new(row: 1, col: 1), occupied_points)).to eq true
      expect(has_point(Battleship::Point.new(row: 1, col: 2), occupied_points)).to eq true
      expect(has_point(Battleship::Point.new(row: 1, col: 3), occupied_points)).to eq false
    end
  end

  describe '#fully_onboard?' do
    it 'returns true if no part of the ship is off the board' do
      horizontal_ship = Battleship::HorizontalShip.new(length: 2,
                                                       table: @table,
                                                       starting_point: @starting_point)
      expect(horizontal_ship).to be_fully_onboard

      horizontal_ship.start_at(Battleship::Point.new(row: 1, col: 2))
      expect(horizontal_ship).to be_fully_onboard

    end

    it 'returns false if part of the ship is off the board' do
      horizontal_ship = Battleship::HorizontalShip.new(length: 3,
                                                       table: @table,
                                                       starting_point: @starting_point)
      horizontal_ship.start_at(Battleship::Point.new(row: 4, col: 4))
      expect(horizontal_ship).not_to be_fully_onboard
    end

  end

  describe '#starting_point' do
    it 'should default to Point(0,0)' do
      horizontal_ship = Battleship::HorizontalShip.new(length: 2,
                                                       table: @table)
      default_starting_point = Battleship::Point.new(row: 1, col: 1)
      expect(horizontal_ship.starting_point.same_as?(default_starting_point)).to eq true
    end
  end
end
