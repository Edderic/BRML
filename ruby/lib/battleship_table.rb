module Battleship
  class Table
    include Enumerable

    attr_reader :row_length, :col_length


    def each_point

    end
    def initialize(hash)
      @row_length = hash.fetch(:row_length)
      @col_length = hash.fetch(:col_length)
      @ships = hash.fetch(:ships)
      @misses = hash.fetch(:misses)
      recreate!
    end

    def rows
      @table
    end

    def recreate!
      @table = (1..row_length).inject([]) do |accum1, item1 |
        accum1 << (1..col_length).inject([]) do |accum2, item2|
        accum2 << Battleship::Point.new(item1, item2)
      end
      end

      @misses.each {|miss| point_at(miss).miss!}
    end

    def each(&block)
      (1..row_length).each do |row|
        (1..col_length).each do |col|
          block.call(point_at([row,col]))
        end
      end
    end

    def sum_of_abs_freqs
      self.inject(0) {|accum, point| accum = accum + point.abs_freq }
    end

    def recalculate_abs_freq!
      recreate!

      @ships.each do |ship|
        ship.table = self
        self.each do |point|
          ship.start_at(point)
          ship.abs_freq!
        end
      end
    end

    def point_at(*args)
      args.flatten!
      row, col = 0,0

      if args.length == 1
        point = args.first
        row, col = point.row, point.col
      else
        row = args[0]
        col = args[1]
      end

      @table[row-1][col-1]
    end
  end
end
