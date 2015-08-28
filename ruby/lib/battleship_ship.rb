module Battleship
  class Ship
    attr_reader :orientation, :starting_point, :length
    attr_accessor :table

    def initialize(hash)
      @length = hash.fetch(:length)
      @table = hash.fetch(:table) { :no_table_initialized }
      @starting_point = hash.fetch(:starting_point) do
        Battleship::Point.new(row: 1, col: 1)
      end
      @sunk = hash.fetch(:sunk) { false }
    end

    def to_s
      occupied_points.inject("sunk: #{sunk?}:") {|accum, point| "#{accum} #{point},"}[0...-1]
    end

    def point(args)
      args.flatten!
      if args.length == 1
        args.first.table = self
        args.first
      else
        Battleship::Point.new(row: args[0], col: args[1], table: self)
      end
    end

    def start_at(point)
      @starting_point = point
    end

    def occupies_valid_points?
      fully_onboard? && !occupies_a_missed_point? && occupied_points_unique
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
      !!@sink
    end

    private

    def occupied_points_unique
      all_occupied_points = @table.ships.map {|ship| ship.occupied_points }.flatten
      all_occupied_points.inject(true) do |accum, point|
        all_occupied_points.select do |some_point|
          point.same_as?(some_point)
        end.count == 1 && accum
      end
    end
  end
end
