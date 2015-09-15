module Battleship
  class FullySunkShip < SimpleDelegator
    attr_reader :ship

    def initialize(ship)
      @ship = ship
      super ship
    end

    # starting point should not be changeable since we already found the spot?
    def start_at(point);; end
    def sink!(point);; end
  end
end
