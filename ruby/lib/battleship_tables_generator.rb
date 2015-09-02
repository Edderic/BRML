# Generates all the possible combinations of ships
# HorizontalShips will not be converted to VerticalShips, and vice versa
# Ships will be converted to both horizontal and vertical ships

module Battleship
  class TablesGenerator
    attr_reader :tables, :misses, :hits, :sunk_pairs, :row_length, :col_length, :ships
    def initialize(hash)
      @ships = hash.fetch(:ships) {[]}
      @misses = hash.fetch(:misses) {[]}
      @hits = hash.fetch(:hits) {[]}
      @sunk_pairs = hash.fetch(:sunk_pairs) {[]}
      @row_length = hash.fetch(:row_length) {[]}
      @col_length = hash.fetch(:col_length) {[]}
    end

    def ships_combinations
      if ships.all? {|ship| ship.class == Battleship::Ship}
        combine(0, [], [])
      else
        @ships
      end
    end

    def tables
      ships_combinations.map do |ships_combo|
        Battleship::Table.new(row_length: row_length,
                              col_length: col_length,
                              ships: ships_combo,
                              sunk_pairs: sunk_pairs,
                              misses: misses,
                              hits: hits)
      end
    end

    def abs_freqs
      reshape(sum_one_dim(points_in_one_dim {|point| point.abs_freq}))
    end

    def num_total_configurations
      tables.inject(0) {|count, table| count = count + table.num_total_configurations}
    end

    private

    # converts rows into one row
    def points_in_one_dim(&block)
      tables.map do |table|
        table.map do |point|
          yield point
        end
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
