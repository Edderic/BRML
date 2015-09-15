module Battleship
  module TableHelper
    def each(&block)
      (1..row_length).each do |row|
        (1..col_length).each do |col|
          block.call(point_at([row,col]))
        end
      end
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
