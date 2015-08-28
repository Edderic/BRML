require 'spec_helper'

describe Battleship::Board do
  describe '10 points missed and one ship is horizontal and another is vertical' do
    before do
      @miss_1 = Battleship::Point.new(row: 1,  col: 10,state:   :missed)
      @miss_2 = Battleship::Point.new(row: 2,  col: 2, state:  :missed)
      @miss_3 = Battleship::Point.new(row: 3,  col: 8, state:  :missed)
      @miss_4 = Battleship::Point.new(row: 4,  col: 4, state:  :missed)
      @miss_5 = Battleship::Point.new(row: 5,  col: 6, state:  :missed)
      @miss_6 = Battleship::Point.new(row: 6,  col: 5, state:  :missed)
      @miss_7 = Battleship::Point.new(row: 7,  col: 4, state:  :missed)
      @miss_8 = Battleship::Point.new(row: 7,  col: 7, state:  :missed)
      @miss_9 = Battleship::Point.new(row: 9,  col: 2, state:  :missed)
      @miss_10 = Battleship::Point.new(row: 9,  col: 9,state:   :missed)

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

    describe '#normalized_freqs' do
      it 'should return the abs_freqs normalized by the max value' do
        normalized_freqs = @board.normalized_freqs
        first_row = normalized_freqs.first
        top_left_corner_abs_freq = first_row.first

        expect(top_left_corner_abs_freq).to eq 0.34615384615384615
      end
    end

    describe '#miss?(point)' do
      it 'should return true if the point was a miss' do
        miss_point = Battleship::Point.new(row: 1,  col: 10 , state: :missed)
        expect( @board.miss?(miss_point)).to eq true
      end

      it 'should return false if the point was not a miss' do
        miss_point = Battleship::Point.new(row: 1,  col: 9 ,state: :missed)
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
        point_of_interest = Battleship::Point.new(row: 1, col: 1, state: :missed)
        expect(@board.abs_freq_at(point_of_interest)).to eq 54
      end
    end

    describe '#best_targets' do
      it 'returns the points with the highest likelihood of overlapping with a ship' do
        def has_point?(some_point, occupied_points)
          occupied_points.any? {|point| point.same_as?(some_point)}
        end

        expect(has_point?(Battleship::Point.new(row: 5, col: 1), @board.best_targets)).to eq true
        expect(has_point?(Battleship::Point.new(row: 10, col: 6), @board.best_targets)).to eq true
      end
    end
  end
end
