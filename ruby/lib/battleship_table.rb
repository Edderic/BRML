module Battleship
  class Table
    include Enumerable

    attr_reader :row_length, :col_length, :ships, :hits, :num_total_configurations

    def initialize(hash)
      @row_length = hash.fetch(:row_length)
      @col_length = hash.fetch(:col_length)
      @ships = hash.fetch(:ships)
      @misses = hash.fetch(:misses) { [] }
      @hits = hash.fetch(:hits) { [] }
      recreate!
    end

    def rel_freqs
      abs_freq!

      abs_freqs.map do |row|
        row.map do |abs_freq|
          abs_freq / @num_total_configurations.to_f
        end
      end
    end

    def unsunk_ships
      @ships.select {|ship| ship.unsunk? }
    end

    def max_abs_freq
      self.max {|point1, point2| point1.abs_freq <=> point2.abs_freq}.abs_freq
    end

    def abs_freqs
      rows.map do |row|
        row.map do |point|
          point.abs_freq
        end
      end
    end

    def rows
      @table
    end

    def recreate!
      @table = (1..row_length).map do |row|
        (1..col_length).map do |col|
          Battleship::Point.new(row: row, col: col, table: self)
        end
      end

      @misses.each {|miss| point_at(miss).miss!; miss.table = self}
      @hits.each {|hit| point_at(hit).hit!; hit.table = self}
      @ships.each {|ship| ship.table = self}
      @num_total_configurations = 0
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

    def abs_freq!
      recreate!

      calc_abs_freq!(unsunk_ships, 0)
    end

    def point_at(*args)
      if point(args).off_table?
        Battleship::Point.new(row: point(args).row,
                              col: point(args).col,
                              table: self
                             )
      else
        @table[point(args).row - 1][point(args).col - 1]
      end
    end


    private

    def calc_abs_freq!(available_ships, index)
      return if index >= available_ships.length

      available_ship = available_ships[index]
      each do |point|
        available_ship.start_at(point)
        calc_abs_freq!(available_ships, index + 1)

        unsunk_ships.each {|ship| ship.abs_freq!; @num_total_configurations += 1 } if valid?
        # Also need to consider when ship can be oriented differently (vertically vs horizontally)
      end
    end

    def valid?
      @ships.all? {|ship| ship.occupies_valid_points?} &&
        @hits.all? { |hit| hit.table = self; hit.on_a_ship?  }
    end

    def point(args)
      args.flatten!
      if args.length == 1
        args.first.table = self
        args.first
      else
        Battleship::Point.new(row: args[0], col: args[1], table: self)
      end
    end
  end
end
