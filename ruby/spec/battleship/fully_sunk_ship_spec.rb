require 'spec_helper'

describe Battleship::FullySunkShip do
  describe '#start_at(point)' do
    it 'does not change the point' do
      starting_point = Battleship::Point.new(row: 1, col: 2)
      another_starting_point = Battleship::Point.new(row: 1, col: 3)
      horizontal_ship = Battleship::HorizontalShip.new(starting_point: starting_point,
                                         length: 3)
      fss = Battleship::FullySunkShip.new(horizontal_ship)
      fss.start_at(another_starting_point)

      expect(fss.starting_point).to eq starting_point
    end
  end

  describe '#sink!' do
    it 'does not do anything since everything has been sunk' do
      starting_point = Battleship::Point.new(row: 1, col: 2)
      point = Battleship::Point.new(row: 1, col:3)
      another_starting_point = Battleship::Point.new(row: 1, col: 3)

      horizontal_ship = Battleship::HorizontalShip.new(starting_point: starting_point,
                                         length: 3)
      fss = Battleship::FullySunkShip.new(horizontal_ship)
      fss.sink!(point)
      expect(point).not_to be_sunk
    end
  end

  describe '#ship' do
    it 'returns the original ship' do
      starting_point = Battleship::Point.new(row: 1, col: 2)
      point = Battleship::Point.new(row: 1, col:3)
      another_starting_point = Battleship::Point.new(row: 1, col: 3)

      horizontal_ship = Battleship::HorizontalShip.new(starting_point: starting_point,
                                         length: 3)
      fss = Battleship::FullySunkShip.new(horizontal_ship)
      expect(fss.ship).to eq horizontal_ship
    end
  end
end
