require 'spec_helper'

describe Battleship::Points do
  describe '#uniq' do
    describe 'when there are duplicate points' do
      it 'should return an an enumerable containi' do
        bp1 = Battleship::Point.new(row: 1, col: 2)
        bp2 = Battleship::Point.new(row: 1, col: 2)
        bps = Battleship::Points.new()
        bps << bp1
        bps << bp2
        expect(bps.uniq.count).to eq 1
      end
    end

    describe 'when there are no duplicates' do
      it 'should return an an enumerable containi' do
        bp1 = Battleship::Point.new(row: 1, col: 2)
        bp2 = Battleship::Point.new(row: 2, col: 2)
        bps = Battleship::Points.new()
        bps << bp1
        bps << bp2
        expect(bps.uniq.count).to eq 2
      end
    end
  end
end
