module Battleship
  class VariableSizeBoard
    extend Forwardable

    def_delegators :reduced_table,
      :abs_freqs,
      :rel_freqs,
      :num_total_configurations,
      :best_targets
    attr_reader :tables,
      :misses,
      :hits,
      :sink_pairs,
      :row_length,
      :col_length,
      :ships

    def initialize(hash)
      @hash = hash
      @row_length = hash.fetch(:row_length)
      @col_length = hash.fetch(:col_length)
    end

    def reduced_table
      tg = tables_generator
      Battleship::ReducedTable.new(tg.abs_freqs,
                                   tg.num_total_configurations)
    end

    def tables_generator
      Battleship::TablesGenerator.new(@hash)
    end
  end
end
