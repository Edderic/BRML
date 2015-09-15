module Battleship
  class ReducedTable
    include Battleship::TableHelper
    include Enumerable

    attr_reader :row_length, :col_length, :abs_freqs, :num_total_configurations

    def initialize(abs_freqs, num_total_configurations)
      @abs_freqs = abs_freqs
      @num_total_configurations = num_total_configurations
      @row_length = @abs_freqs.length
      @col_length = @abs_freqs[0].length
      @table = rebuild_table
    end

    def best_targets
      select do |point|
        point.abs_freq == max_abs_freq
      end
    end
  end
end
