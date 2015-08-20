require 'spec_helper'

describe Battleship::Board do
  before do
    @miss_1 = Battleship::Point.new(1, 10, :missed)
    @miss_2 = Battleship::Point.new(2, 2, :missed)
    @miss_3 = Battleship::Point.new(3, 8, :missed)
    @miss_4 = Battleship::Point.new(4, 4, :missed)
    @miss_5 = Battleship::Point.new(5, 6, :missed)
    @miss_6 = Battleship::Point.new(6, 5, :missed)
    @miss_7 = Battleship::Point.new(7, 4, :missed)
    @miss_8 = Battleship::Point.new(7, 7, :missed)
    @miss_9 = Battleship::Point.new(9, 2, :missed)
    @miss_10 = Battleship::Point.new(9, 9, :missed)

    @misses = [@miss_1, @miss_2, @miss_3, @miss_4, @miss_5,
               @miss_6, @miss_7, @miss_8, @miss_9, @miss_10 ]

    @ship_1 = Battleship::VerticalShip.new(length: 5)
    @ship_2 = Battleship::HorizontalShip.new(length: 5)

    @ships = [@ship_1, @ship_2]

    @board = Battleship::Board.new(misses: @misses, ships: @ships)
  end

  describe '#row_length' do
    it 'should return 10' do
      expect(@board.row_length).to eq 10
    end
  end

  describe '#col_length' do
    it 'should return 10' do
      expect(@board.col_length).to eq 10
    end
  end

  describe '#miss?(point)' do
    it 'should return true if the point was a miss' do
      miss_point = Battleship::Point.new(1, 10 , :missed)
      expect( @board.miss?(miss_point)).to eq true
    end

    it 'should return false if the point was not a miss' do
      miss_point = Battleship::Point.new(1, 9 , :missed)
      expect( @board.miss?(miss_point)).to eq false
    end
  end

  describe '#point_at(row, col)' do
    it 'should return the point with those attributes' do
      row = 1
      col = 1

      point = @board.point_at(row, col)

      expect(point.row).to eq row
      expect(point.col).to eq col
    end
  end

  describe '#abs_freq_at(point)' do
    it'should return the number of possible hits' do
      point_of_interest = Battleship::Point.new(1, 1, :missed)
      expect(@board.abs_freq_at(point_of_interest)).to eq 2
    end
  end

  describe '#best_targets' do
    it 'returns the points with the highest likelihood of overlapping with a ship' do
      def has_point(some_point, occupied_points)
        occupied_points.any? {|point| point.row == some_point.row && point.col == some_point.col}
      end
      expect(has_point(Battleship::Point.new(1,5), @board.best_targets)).to eq true
      expect(has_point(Battleship::Point.new(2,7), @board.best_targets)).to eq true
      expect(has_point(Battleship::Point.new(3,3), @board.best_targets)).to eq true
      expect(has_point(Battleship::Point.new(4,9), @board.best_targets)).to eq true
      expect(has_point(Battleship::Point.new(5,1), @board.best_targets)).to eq true
      expect(has_point(Battleship::Point.new(5,3), @board.best_targets)).to eq true
      expect(has_point(Battleship::Point.new(6,10), @board.best_targets)).to eq true
      expect(has_point(Battleship::Point.new(8,3), @board.best_targets)).to eq true
      expect(has_point(Battleship::Point.new(8,6), @board.best_targets)).to eq true
      expect(has_point(Battleship::Point.new(8,8), @board.best_targets)).to eq true
      expect(has_point(Battleship::Point.new(10,6), @board.best_targets)).to eq true
    end
  end
end
