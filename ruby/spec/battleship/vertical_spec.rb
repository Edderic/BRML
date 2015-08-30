require 'spec_helper'

describe Battleship::VerticalShip do
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

  describe '#occupied_points' do
    it 'returns a list of occupied points' do
      vertical_ship = Battleship::VerticalShip.new(length: 2,
                                                       table: @table,
                                                       starting_point: @starting_point)

      occupied_points = vertical_ship.occupied_points

      expect(has_point(Battleship::Point.new(row: 1,col: 1), occupied_points)).to eq true
      expect(has_point(Battleship::Point.new(row: 2,col: 1), occupied_points)).to eq true
      expect(has_point(Battleship::Point.new(row: 3,col: 1), occupied_points)).to eq false
    end
  end

  describe '#occupies_a_missed_point?' do
    it 'returns true if ship occupies a missed point' do
      starting_point = Battleship::Point.new(row: 2,col: 2)
      vertical_ship = Battleship::VerticalShip.new(length: 2,
                                                       table: @table,
                                                       starting_point: starting_point)
      expect(vertical_ship).to be_occupies_a_missed_point
    end

    it 'returns false if ship does not occupy a missed point' do
      starting_point = Battleship::Point.new(row: 1,col: 1)
      vertical_ship = Battleship::VerticalShip.new(length: 2,
                                                       table: @table,
                                                       starting_point: starting_point)
      expect(vertical_ship).not_to be_occupies_a_missed_point
    end
  end

  describe '#occupies?(point)' do
    it 'returns true if occupies the point' do
      vertical_ship = Battleship::VerticalShip.new(length: 2,
                                                       table: @table,
                                                       starting_point: @starting_point)

      expect(vertical_ship.occupies_point?(1,1)).to eq true
      expect(vertical_ship.occupies_point?(2,1)).to eq true
      expect(vertical_ship.occupies_point?(3,1)).to eq false
    end
  end

  describe '#fully_onboard?' do
    it 'returns true if no part of the ship is off the board' do
      vertical_ship = Battleship::VerticalShip.new(length: 2,
                                                   orientation: :vertical,
                                                   table: @table,
                                                   starting_point: @starting_point)
      expect(vertical_ship).to be_fully_onboard

      vertical_ship.start_at(Battleship::Point.new(row: 2,col: 1))
      expect(vertical_ship).to be_fully_onboard

    end

    it 'returns false if part of the ship is off the board' do
      vertical_ship = Battleship::VerticalShip.new(length: 2,
                                                   orientation: :vertical,
                                                   table: @table,
                                                   starting_point: @starting_point)
      vertical_ship.start_at(Battleship::Point.new(row: 3,col: 1))
      expect(vertical_ship).not_to be_fully_onboard
    end
  end

  describe '#abs_freq!' do
    it 'should update the values of occupied points' do
      vertical_ship = Battleship::VerticalShip.new(length: 2,
                                                   table: @table,
                                                   starting_point: @starting_point)
      vertical_ship.abs_freq!
      expect(@table.point_at(1,1).abs_freq).to eq 1
    end
  end

  describe '#to_horizontal' do
    it 'should return a NullShip' do
      vertical_ship = Battleship::VerticalShip.new(length: 2,
                                                   table: @table,
                                                   starting_point: @starting_point)
      null_ship = vertical_ship.to_horizontal
      expect(null_ship.class).to eq Battleship::NullShip
    end
  end
end
