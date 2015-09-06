module Battleship
  class Table
    @@count = 0
    include Enumerable

    attr_reader :row_length,
      :col_length,
      :ships,
      :hits,
      :num_total_configurations,
      :sink_pairs

    def initialize(hash)
      @row_length = hash.fetch(:row_length)
      @col_length = hash.fetch(:col_length)
      @ships = hash.fetch(:ships)
      @misses = hash.fetch(:misses) { [] }
      @sink_pairs = hash.fetch(:sink_pairs) { [] }
      @hits = hash.fetch(:hits) { [] }
      # abs_freq!
      recreate!
    end

    def num_times_matching_sink_pair
      if sink_pairs.empty?
        return 0
      end

      count = 0

      sink_pair = sink_pairs.first
      sink_ship_length = sink_pair.sink_ship_length
      sink_point = sink_pair.sink_point
      unsunk_ships_of_specified_length(sink_ship_length).each do |unsunk_ship|
        each do |point|
          unsunk_ship.start_at(point)
          count += 1 if unsunk_ship.sinkable?(sink_point)
        end
      end

      count
    end

    def sink!(sink_point, length)
      # need to make sure that at least one unsunken ship is able to have
      # all its points covered

      unsunk_ships_of_specified_length(length).each do |unsunk_ship|
        each do |point|
          unsunk_ship.start_at(point)
          unsunk_ship.sink!(sink_point)
        end
      end
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

      @hits = @hits.map {|hit| hit.clone}
      @misses.each {|miss| point_at(miss).miss!; miss.table = self}
      @hits.each {|hit| point_at(hit).hit!; hit.table = self}
      @ships.each {|ship| ship.table = self}
      # @sink_pairs.each { |sp| sink!(sp[:sink_point], sp[:ship_length]) }
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
      end
    end

    def valid?
      unsunk_ships.all? {|ship| ship.occupies_valid_points?} &&
        @hits.all? { |hit| hit.table = self; hit.on_an_unsunk_ship?  }
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

    def unsunk_ships_of_specified_length(length)
      unsunk_ships.select {|ship| ship.length == length}
    end
  end
end
