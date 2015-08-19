require 'spec_helper'

describe Battleship::HorizontalShip do
  before do
    @starting_point = Battleship::Point.new(1,1)
    @table = (1..3).map do |row|
      (1..3).map do |col|
        Battleship::Point.new(row,col)
      end
    end

    def @table.row_length; 3; end
    def @table.col_length; 3; end
    def has_point(some_point, occupied_points)
      occupied_points.any? {|point| point.row == some_point.row && point.col == some_point.col}
    end
    @table[2][2].miss!

    def @table.point_at(row, col)
      self[row-1][col-1]
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
      def @table.point_at(row, col)
        self[row-1][col-1]
      end
      horizontal_ship = Battleship::HorizontalShip.new(length: 2,
                                                       table: @table,
                                                       starting_point: @starting_point)

      occupied_points = horizontal_ship.occupied_points

      expect(has_point(Battleship::Point.new(1,1), occupied_points)).to eq true
      expect(has_point(Battleship::Point.new(1,2), occupied_points)).to eq true
      expect(has_point(Battleship::Point.new(1,3), occupied_points)).to eq false
    end
  end

  describe '#occupies_a_missed_point?' do
    it 'returns true if ship occupies a missed point' do
      starting_point = Battleship::Point.new(3,2)
      horizontal_ship = Battleship::HorizontalShip.new(length: 2,
                                                       table: @table,
                                                       starting_point: starting_point)
      expect(horizontal_ship).to be_occupies_a_missed_point
    end

    it 'returns false if ship does not occupy a missed point' do
      starting_point = Battleship::Point.new(2,2)
      horizontal_ship = Battleship::HorizontalShip.new(length: 2,
                                                       table: @table,
                                                       starting_point: starting_point)
      expect(horizontal_ship).not_to be_occupies_a_missed_point
    end
  end

  describe '#occupies_valid_points?' do
    it 'returns true if all points are valid' do
      starting_point = Battleship::Point.new(1,1)
      horizontal_ship = Battleship::HorizontalShip.new(length: 2,
                                                       table: @table,
                                                       starting_point: starting_point)
      expect(horizontal_ship).to be_occupies_valid_points
    end

    it 'returns false if some points are not valid' do
      starting_point = Battleship::Point.new(3,3)
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

      horizontal_ship.start_at(Battleship::Point.new(1,2))
      expect(horizontal_ship).to be_fully_onboard
    end

    it 'returns false if part of the ship is off the board' do
      horizontal_ship = Battleship::HorizontalShip.new(length: 2,
                                                       table: @table,
                                                       starting_point: @starting_point)
      horizontal_ship.start_at(Battleship::Point.new(1,3))
      expect(horizontal_ship).not_to be_fully_onboard
    end
  end
end
