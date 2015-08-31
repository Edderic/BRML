# Generates all the possible combinations of ships
# HorizontalShips will not be converted to VerticalShips, and vice versa
# Ships will be converted to both horizontal and vertical ships

module Battleship
  class TablesGenerator
    attr_reader :tables, :unsunk_ships, :misses, :hits, :sunk_pairs
    def initialize(hash)
      @unsunk_ships = hash.fetch(:unsunk_ships) {[]}
      @misses = hash.fetch(:misses) {[]}
      @hits = hash.fetch(:hits) {[]}
      @sunk_pairs = hash.fetch(:sunk_pairs) {[]}

      # for each unsunk ship
      #   get the horizontal version
      #     recurse
      #   get the vertical version
      #     recurse
      # return the different configurations
      # @tables
    end

    def unsunk_ships_combinations
      combine(0, [], [])
    end

    private

    # []
      # [H_2, H_3]
      # [H_2, V_3]

    def combine(ship_index, combinations, combination)
      if ship_index >= @unsunk_ships.length
        combinations << combination.clone
        return combinations
      end

      unsunk_ship = @unsunk_ships[ship_index]

      oriented_ship = unsunk_ship.to_horizontal
      # combination << oriented_ship unless oriented_ship.class == Battleship::NullShip
      combine(ship_index + 1, combinations, combination.clone << oriented_ship)

      oriented_ship = unsunk_ship.to_vertical
      # combination << oriented_ship unless oriented_ship.class == Battleship::NullShip

      combine(ship_index + 1, combinations, combination.clone << oriented_ship)
      combinations
    end
  end
end
