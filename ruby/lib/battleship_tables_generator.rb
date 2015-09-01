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
    end

    def unsunk_ships_combinations
      if unsunk_ships.all? {|ship| ship.class == Battleship::Ship}
        combine(0, [], [])
      else
        @unsunk_ships
      end
    end

    private

    def combine(ship_index, combinations, combination)
      if ship_index >= @unsunk_ships.length
        combinations << combination.clone
        return combinations
      end

      unsunk_ship = @unsunk_ships[ship_index]

      combine(ship_index + 1, combinations, ship(ship_index, :to_horizontal, combination))
      combine(ship_index + 1, combinations, ship(ship_index, :to_vertical, combination))
      combinations
    end

    def ship(ship_index, orientation, combination)
      unsunk_ship = @unsunk_ships[ship_index]
      if unsunk_ship.send(orientation).class == Battleship::NullShip
        require 'pry'; binding.pry
        combination.clone
      else
        combination.clone << unsunk_ship.send(orientation)
      end
    end
  end
end
