# A table usually has ships that have unspecified orientation (i.e. a ship
# could be horizontal or vertical). In the calculation of absolute frequencies,
# we create ships of unknown orientation to ones with specific orientation
# (i.e. create a HorizontalShip and a VerticalShip).
#
# In order to keep tests passingi where ships actually do have a given
# orientation, we create a NullShip that makes the table think that the
# configuration is invalid, so that absolute frequencies do NOT get updated.

module Battleship
  class NullShip < Ship
    def initialize
    end

    def occupies_point?(point)
      false
    end

    def fully_onboard?
      false
    end

    def occupied_points
      []
    end
  end
end
