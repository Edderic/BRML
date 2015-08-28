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

    def on_a_ship?
      @table.ships.any? do |ship|
        ship.occupies_point? self
      end
    end

    def to_s
      "(#{row},#{col})"
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
