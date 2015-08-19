module Battleship
  class VerticalShip < Battleship::Ship
    def occupies_point?(row, col)
      starting_point.col == col &&
        (starting_point.row...starting_point.row + @length).any? {|item| item == row}
    end

    def fully_onboard?
      @table.row_length >= @starting_point.row - 1 + @length
    end

    def occupied_points
      (@starting_point.row...@starting_point.row + @length).map do |row|
        @table.point_at(row, @starting_point.col)
      end
    end
  end
end
