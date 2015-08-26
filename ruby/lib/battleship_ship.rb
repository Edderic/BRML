module Battleship
  class Ship
    attr_reader :orientation, :starting_point
    attr_accessor :table

    def initialize(hash)
      @length = hash.fetch(:length)
      @table = hash.fetch(:table) { :no_table_initialized }
      @starting_point = hash.fetch(:starting_point) { Battleship::Point.new(1,1) }
      @sunk = hash.fetch(:sunk) { false }
    end

    def start_at(point)
      @starting_point = point
    end

    def occupies_valid_points?
      fully_onboard? && !occupies_a_missed_point? && occupied_points_unique
    end

    def occupied_points_unique
      all_occupied_points = @table.ships.map {|ship| ship.occupied_points }.flatten
      all_occupied_points.inject(true) do |accum, point|
        all_occupied_points.select do |some_point|
          point.same_as?(some_point)
        end.count == 1 && accum
      end
    end

    def occupies_a_missed_point?
      occupied_points.any? {|point| point.missed? }
    end

    def abs_freq!
      occupied_points.each {|point| point.abs_freq += 1} if self.occupies_valid_points?
    end

    def unsunk?
      !sunk?
    end

    def sink!
      @sink = true
    end

    def sunk?
      @sink
    end
  end
end
