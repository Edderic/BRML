module Battleship
  class HorizontalShip < Battleship::Ship
    def fully_onboard?
      @table.col_length >= @starting_point.col - 1 + @length
    end

    def occupies_point?(*args)
      starting_point.row == point(args).row &&
        (starting_point.col...starting_point.col + @length).any? {|item| item == point(args).col}
    end

    def occupied_points
      (@starting_point.col...@starting_point.col + @length).map do |col|
        @table.point_at(@starting_point.row, col)
      end
    end
  end
end
