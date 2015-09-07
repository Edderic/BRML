# Generates all the possible combinations of ships
# HorizontalShips will not be converted to VerticalShips, and vice versa
# Ships will be converted to both horizontal and vertical ships

module Battleship
  class TablesGenerator
    attr_reader :tables, :misses, :hits, :sink_pairs, :row_length, :col_length, :ships
    def initialize(hash)
      @ships = hash.fetch(:ships) {[]}
      @misses = hash.fetch(:misses) {[]}
      @hits = hash.fetch(:hits) {[]}
      @sink_pairs = hash.fetch(:sink_pairs) {[]}
      @row_length = hash.fetch(:row_length)
      @col_length = hash.fetch(:col_length)

      @sink_pairs.each {|sunk_pair| sunk_pair.tables_generator = self}
      @tables = reinitialize_tables
    end

    def ships_combinations
      if ships.all? {|ship| ship.class == Battleship::Ship}
        combine(0, [], [])
      else
        @ships
      end
    end

    def num_times_matching_sink_pair
      tables.inject(0) do |count, table|
        count = count + table.num_times_matching_sink_pair
      end
    end

    def reinitialize_tables
      ships_combinations.map do |ships_combo|
        table = Battleship::Table.new(row_length: row_length,
                              col_length: col_length,
                              ships: Array(ships_combo),
                              sink_pairs: sink_pairs,
                              misses: misses,
                              hits: hits)
        table.recreate!
        table
      end
    end

    def abs_freqs
      filtered_tables.each do |table|
        sink_pairs.each do |sink_pair|
          table.sink!(sink_pair.sink_point, sink_pair.sink_ship_length)
        end
      end

      @tables.each {|table| table.abs_freq!}
      reshape(sum_one_dim(points_in_one_dim {|point| point.abs_freq}))
    end

    def num_total_configurations
      tables.inject(0) {|count, table| count = count + table.num_total_configurations}
    end

    private

    # converts rows into one row
    def points_in_one_dim(&block)
      filtered_tables.map do |table|
        table.map do |point|
          yield point
        end
      end
    end

    def filtered_tables
      if num_times_matching_sink_pair == 1
        tables.select {|table| table.num_times_matching_sink_pair == 1}
      elsif num_times_matching_sink_pair == 0 && sink_pairs.empty?
        null_table = Battleship::Table.new(row_length: row_length,
                                    col_length: col_length,
                                   ships: [])
        def null_table.num_total_configurations
          0
        end
        # require 'pry'; binding.pry
        [null_table]
      else
        # require 'pry'; binding.pry
        tables
      end
    end

    # converts back to 2-d
    def reshape(one_dim)
      (0...row_length).inject([]) do |rows, row_index|
        start_index = row_index * col_length
        end_index = (row_index+1) * col_length
        range = (start_index)...(end_index)
        rows << one_dim[range]
      end
    end

    def sum_one_dim(one_dim)
      one_dim.inject do |sum, row|
        (0...row.length).to_a.each do |index|
          sum[index] = sum[index] + row[index]
        end

        sum
      end
    end

    def combine(ship_index, combinations, combination)
      if ship_index >= @ships.length
        combinations << combination.clone
        return combinations
      end

      ship = @ships[ship_index]

      combine(ship_index + 1, combinations, ship(ship_index, :to_horizontal, combination))
      combine(ship_index + 1, combinations, ship(ship_index, :to_vertical, combination))
      combinations
    end

    def ship(ship_index, orientation, combination)
      ship = @ships[ship_index]
      if ship.send(orientation).class == Battleship::NullShip
        combination.clone
      else
        combination.clone << ship.send(orientation)
      end
    end
  end
end
