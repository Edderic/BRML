require 'spec_helper'

describe 'NullShip' do
  describe '#occupies_point?' do
    it 'should always be false' do
      null_ship = Battleship::NullShip.new
      point = double('point')

      expect(null_ship.occupies_point?(point)).to eq false
    end
  end

  describe '#fully_onboard?' do
    it 'should always be false' do
      null_ship = Battleship::NullShip.new

      expect(null_ship).not_to be_fully_onboard
    end
  end

  describe '#occupied_points' do
    it 'should return an empty array' do
      null_ship = Battleship::NullShip.new

      expect(null_ship.occupied_points).to be_empty
    end
  end
end
