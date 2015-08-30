module Battleship
  class VerticalShip < Battleship::Ship
    def occupies_point?(*args)
      starting_point.col == point(args).col &&
        (starting_point.row...starting_point.row + @length).any? do |item|
        item == point(args).row
      end
    end

    def fully_onboard?
      @table.row_length >= @starting_point.row - 1 + @length
    end

    def occupied_points
      (@starting_point.row...@starting_point.row + @length).map do |row|
        @table.point_at(row, @starting_point.col)
      end
    end

    def to_horizontal
      Battleship::NullShip.new
    end
  end
end
