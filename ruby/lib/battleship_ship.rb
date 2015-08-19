module Battleship
  class Ship
    attr_reader :orientation, :starting_point
    attr_accessor :table

    def initialize(hash)
      @length = hash.fetch(:length)
      @table = hash.fetch(:table) { :no_table_initialized }
      @starting_point = hash.fetch(:starting_point) { :no_starting_point }
    end

    def start_at(point)
      @starting_point = point
    end

    def occupies_valid_points?
      fully_onboard? && !occupies_a_missed_point?
    end

    def occupies_a_missed_point?
      occupied_points.any? {|point| point.missed? }
    end

    def abs_freq!
      occupied_points.each {|point| point.abs_freq += 1} if self.occupies_valid_points?
    end
  end
end
