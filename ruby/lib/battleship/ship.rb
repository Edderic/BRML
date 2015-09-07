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
      @starting_point = point if unsunk?
    end

    def occupies_valid_points?
      fully_onboard? &&
        !occupies_a_missed_point? &&
        # !occupies_a_sunk_point? &&
        occupied_points_unique?
    end

    def occupies_a_sunk_point?
      occupied_points.any? {|point| point.sunk? }
    end

    def occupies_a_missed_point?
      occupied_points.any? {|point| point.missed? }
    end

    def abs_freq!(&block)
      return unless self.occupies_valid_points?

      occupied_points.each do |point|
        point.abs_freq += 1 unless point.sunk? || point.hit?
      end

      yield block if block_given?
    end

    def unsunk?
      !sunk?
    end

    def sinkable?(sink_point)
      occupied_points.select {|point| point.sunk? || point.hit? }.count >= occupied_points.length - 1 &&
        @table.point_at(sink_point).untried? &&
        occupied_points.any? {|point| point.same_as?(sink_point)}

    end

    def sink!(sink_point)
      if sinkable?(sink_point)
        @sunk = true
        occupied_points.each do |point|
          point.sink!
          @table.hits.reject! {|hit| hit.same_as?(point) }
        end
        @table.point_at(sink_point).sink!
      end
    end

    def sunk?
      @sunk
    end

    # used to convert ships of unknown orientation to specified versions
    def to_vertical
      Battleship::VerticalShip.new(length: @length,
                                   starting_point: @starting_point,
                                   table: @table)
    end

    def to_horizontal
      Battleship::HorizontalShip.new(length: @length,
                                     starting_point: @starting_point,
                                     table: @table)
    end

    private

    def occupied_points_unique?
      all_occupied_points = @table.ships.map {|ship| ship.occupied_points }.flatten
      all_occupied_points.inject(true) do |accum, point|
        all_occupied_points.select do |some_point|
          point.same_as?(some_point)
        end.count == 1 && accum
      end
    end
  end
end
