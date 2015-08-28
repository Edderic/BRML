require 'spec_helper'

describe Battleship::HorizontalShip do
  before do
    @starting_point = Battleship::Point.new(row: 1,col: 1)
    ships = []
    misses = [Battleship::Point.new(row: 2, col: 2)]
    hash = {row_length: 3, col_length: 3, ships: ships, misses: misses}
    @table = Battleship::Table.new(hash)

    def has_point(some_point, occupied_points)
      occupied_points.any? {|point| point.same_as? some_point }
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

      expect(has_point(Battleship::Point.new(row: 1,col: 1), occupied_points)).to eq true
      expect(has_point(Battleship::Point.new(row: 1,col: 2), occupied_points)).to eq true
      expect(has_point(Battleship::Point.new(row: 1,col: 3), occupied_points)).to eq false
    end
  end

  describe '#occupies_a_missed_point?' do
    it 'returns true if ship occupies a missed point' do
      starting_point = Battleship::Point.new(row: 2,col: 2)
      horizontal_ship = Battleship::HorizontalShip.new(length: 2,
                                                       table: @table,
                                                       starting_point: starting_point)
      expect(horizontal_ship).to be_occupies_a_missed_point
    end

    it 'returns false if ship does not occupy a missed point' do
      starting_point = Battleship::Point.new(row: 3,col: 2)
      horizontal_ship = Battleship::HorizontalShip.new(length: 2,
                                                       table: @table,
                                                       starting_point: starting_point)
      expect(horizontal_ship).not_to be_occupies_a_missed_point
    end
  end

  describe '#occupies_valid_points?' do
    it 'returns true if all points are valid' do
      starting_point = Battleship::Point.new(row: 1,col: 1)
      horizontal_ship = Battleship::HorizontalShip.new(length: 2,
                                                       table: @table,
                                                       starting_point: starting_point)
      expect(horizontal_ship).to be_occupies_valid_points
    end

    it 'returns false if some points are not valid' do
      starting_point = Battleship::Point.new(row: 3,col: 3)
      horizontal_ship = Battleship::HorizontalShip.new(length: 2,
                                                       table: @table,
                                                       starting_point: starting_point)
      expect(horizontal_ship).not_to be_occupies_valid_points
    end
  end

  describe '#fully_onboard?' do
    it 'returns true if no part of the ship is off the board' do
      horizontal_ship = Battleship::HorizontalShip.new(length: 2,
                                                       table: @table,
                                                       starting_point: @starting_point)
      expect(horizontal_ship).to be_fully_onboard

      horizontal_ship.start_at(Battleship::Point.new(row: 1,col: 2))
      expect(horizontal_ship).to be_fully_onboard
    end

    it 'returns false if part of the ship is off the board' do
      horizontal_ship = Battleship::HorizontalShip.new(length: 2,
                                                       table: @table,
                                                       starting_point: @starting_point)
      horizontal_ship.start_at(Battleship::Point.new(row: 1,col: 3))
      expect(horizontal_ship).not_to be_fully_onboard
    end
  end
end
