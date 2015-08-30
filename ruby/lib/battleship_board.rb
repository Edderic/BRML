require 'forwardable'

module Battleship
  class Board
    extend Forwardable

    def_delegators :@table, :abs_freqs, :rel_freqs, :point_at

    attr_reader :table

    def initialize(init_hash)
      @misses = init_hash[:misses]
      @ships = init_hash[:ships]
      @table = Battleship::Table.new(row_length:row_length,
                                     col_length: col_length,
                                     misses: @misses,
                                     ships: @ships)
      # table should listen to changes in ship status
      # if hit, then recalculate frequencies...
      @table.abs_freq!
    end

    def miss?(point)
      @misses.select {|miss| miss.same_as?(point) }.count >= 1
    end

    def row_length
      10
    end

    def col_length
      10
    end

    def best_targets
      @table.select {|point| point.abs_freq == @table.max_abs_freq}
    end

    def normalized_freqs
      abs_freqs.map do |row|
        row.map do |abs_freq|
          abs_freq / @table.max_abs_freq.to_f
        end
      end
    end

    def abs_freq_at(point)
      point_at(point).abs_freq
    end
  end
end
