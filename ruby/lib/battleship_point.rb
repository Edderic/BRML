module Battleship
  class Point
    attr_reader :row, :col
    attr_accessor :abs_freq

    def initialize(row, col, *args)
      @row = row
      @col = col
      @abs_freq = 0
      @state = args.first || :untried
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
