# sinking should be the SinkPair's job
# SinkPair#sink! would sink the sunk point and the other associated sink points
# it is not ambiguous. If ambiguous, we mark the sink point as "sunk", but we
# do not sink the other associated points.
#
# Looks like we need to have a SinkPair for TablesGenerator
# and a SinkPair for Tables
#
# TablesGenerator#ambiguous? checks the response of each Tables#ambiguous?
# If one Table is ambiguous, then the TablesGenerator's sinkpair is also
# ambiguous


module Battleship
  class SinkPair
    attr_accessor :tables_generator, :table
    attr_reader :sink_point, :sink_ship_length

    def initialize(args)
      @sink_point = args.fetch(:point)
      @sink_ship_length = args.fetch(:ship_length)
    end

    def valid?
      # TODO: might have more than one ship matching

      @table.ships.select do |ship|
        ship.length == sink_ship_length
      end.any? do |ship|
        ship.occupies_point?(sink_point)
      end
    end

    def sink!
      if ambiguous_sink_pair?
        table.point_at(sink_point).sink!
        @fully_sunk = false
        return
      end

      # Not ambiguous anymore

      table.calculate_across_all_points!(table.unsunk_ships, 0) do
        table.unsunk_ships.each do |unsunk_ship|
          if unsunk_ship.length == sink_ship_length && !unsunk_ship.fully_sunk? && unsunk_ship.sinkable?(sink_point)
            unsunk_ship.sink!(sink_point)
            fully_sunk!(unsunk_ship)
            break
          end
        end
      end
    end

    def fully_sunk?
      @fully_sunk
    end

    def fully_sunk!(ship)
      @fully_sunk = true
      table.add_fully_sunk_ship!(ship)
      table.sink_pairs.reject! {|sp| sp == self}
    end

    def num_times_matching_sink_pair
      if table.sink_pairs.empty?
        return 0
      end

      start_points = Battleship::Points.new

      table.calculate_across_all_points!(table.unsunk_ships, 0) do
        table.unsunk_ships.each do |ship|
          if ship.sinkable?(sink_point) && ship.length == sink_ship_length
            start_points << ship.starting_point
          end
        end
      end

      start_points.uniq.count
    end

    def ambiguous_sink_pair?
      num_times_matching_sink_pair != 1
    end
  end
end
