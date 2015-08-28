require 'spec_helper'

describe Battleship::Ship do
  before do
    @starting_point = Battleship::Point.new(row: 1, col: 1)
    @table = Battleship::Table.new(row_length: 5,
                                   col_length: 5,
                                   ships: [])
  end

  describe '#to_s' do
    it 'should return print out the starting point and occupied_points' do
      starting_point = Battleship::Point.new(row: 3,col: 4)
      ship_1 = Battleship::HorizontalShip.new(length: 4, starting_point: starting_point,
                                             table: @table)
      ship_1.sink!
      expect(ship_1.to_s).to eq "sunk: true: (3,4), (3,5), (3,6), (3,7)"
    end
  end

  describe '#sunk?' do
    it 'returns true if not all parts are hit' do
      ship_1 = Battleship::HorizontalShip.new(length: 4)
      ship_1.sink!
      expect(ship_1).to be_sunk
      expect(ship_1).not_to be_unsunk
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
      ship_1 = Battleship::HorizontalShip.new(length: 4,
                                              starting_point: point_1)
      ship_2 = Battleship::HorizontalShip.new(length: 3,
                                              starting_point: point_2)
      ships = [ship_1, ship_2]
      table = Battleship::Table.new(row_length: 1, col_length: 10, ships: ships, misses: [])

      expect(ship_1).to be_occupies_valid_points
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
