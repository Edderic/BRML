module Battleship
  module TableHelper
    attr_reader :row_length,
      :col_length,
      :ships,
      :hits,
      :num_total_configurations,
      :sink_pairs,
      :fully_sunk_ships

    def initialize(hash)
      @row_length = hash.fetch(:row_length)
      @col_length = hash.fetch(:col_length)
      @ships = hash.fetch(:ships)
      @misses = hash.fetch(:misses) { [] }
      @sink_pairs = hash.fetch(:sink_pairs) { [] }
      @hits = hash.fetch(:hits) { [] }
      @fully_sunk_ships = []
      recreate!
    end

    def unsunk_ships
      @ships.select {|ship| ship.unsunk? }
    end

    def to_s
      (1..row_length).inject("") do |total_str, row|
        total_str + (1..col_length).inject("") do |row_str, col|
          "#{row_str}#{point_at(row, col).to_s} "
        end.rstrip + "\n"
      end + ships.inject("") {|str, ship| "#{str}#{ship.to_s}\n"}.lstrip
    end

    def debug?
      true
    end

    def debug(comment, &block)
      if debug?
        puts "\n"
        puts "Before the #{comment}"
        puts to_s
        puts "\n"
      end

      yield block

      if debug?
        puts "\n"
        puts "After the #{comment}"
        puts to_s
        puts "\n"
      end
    end

    def calculate_across_all_points!(available_ships, index, &block)
      return if index >= available_ships.length

      available_ship = available_ships[index]
      each do |point|
        available_ship.start_at(point)
        calculate_across_all_points!(available_ships, index + 1, &block)

        if valid?
          yield
        end
      end
    end

    def rows
      @table
    end

    def each(&block)
      (1..row_length).each do |row|
        (1..col_length).each do |col|
          block.call(point_at([row,col]))
        end
      end
    end

    def recreate!
      @table = (1..row_length).map do |row|
        (1..col_length).map do |col|
          Battleship::Point.new(row: row, col: col, table: self)
        end
      end

      @hits = @hits.map {|hit| hit.clone}
      @misses.each {|miss| point_at(miss).miss!; miss.table = self}
      @hits.each {|hit| point_at(hit).hit!; hit.table = self}
      @ships.each {|ship| ship.table = self}
      @sink_pairs.each { |sp| sp.table = self}
      @num_total_configurations = 0
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

    def abs_freqs
      rows.map do |row|
        row.map do |point|
          point.abs_freq
        end
      end
    end

    def rel_freqs
      abs_freqs.map do |row|
        row.map do |abs_freq|
          abs_freq / num_total_configurations.to_f
        end
      end
    end

    def max_abs_freq
      max {|point1, point2| point1.abs_freq <=> point2.abs_freq}.abs_freq
    end

    def rebuild_table
      (1..row_length).map do |row|
        (1..col_length).map do |col|
          point = Battleship::Point.new(row: row, col: col)
          point.abs_freq = @abs_freqs[row-1][col-1]
          point
        end
      end
    end
  end
end
