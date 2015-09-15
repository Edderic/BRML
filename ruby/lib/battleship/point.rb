module Battleship
  class Point
    attr_reader :row, :col
    attr_accessor :abs_freq, :table

    def initialize(hash)
      @row = hash.fetch(:row)
      @col = hash.fetch(:col)
      @abs_freq = 0
      @table = hash.fetch(:table) {:no_table_initialized}
      @state = hash.fetch(:state) {:untried}
    end

    def has_coords?(r,c)
      row == r && col == c
    end

    def neighboring_points
      [
        @table.point_at(row-1, col),
        @table.point_at(row+1, col),
        @table.point_at(row, col+1),
        @table.point_at(row, col-1)
      ]
    end

    def on_a_ship?
      @table.ships.any? do |ship|
        ship.occupies_point? self
      end
    end

    def on_an_unsunk_ship?
      @table.unsunk_ships.any? do |ship|
        ship.occupies_point? self
      end
    end

    def to_s
      "(#{row},#{col} | #{@state.to_s[0]} | #{abs_freq})"
    end

    def off_table?
      row > @table.row_length || col > @table.col_length
    end

    def hit!
      @state = :hit
    end

    def hit?
      @state == :hit
    end

    def sink!
      @state = :sunk
    end

    def sunk?
      @state == :sunk
    end

    def miss!
      @state = :missed
    end

    def missed?
      @state == :missed
    end

    def untried?
      @state == :untried
    end

    def same_as?(point)
      row == point.row && col == point.col
    end
  end
end
