# sinking should be the SinkPair's job
# SinkPair#sink! would sink the sunk point and the other associated sink points it is not ambiguous. If ambiguous, we mark the sink point as "sunk", but we do not sink the other associated points.

module Battleship
  class SinkPair
    attr_accessor :tables_generator, :table
    attr_reader :sink_point, :sink_ship_length
    def initialize(args)
      @sink_point = args.fetch(:point)
      @sink_ship_length = args.fetch(:ship_length)
    end

    def num_times_matching_sink_pair
      if table.sink_pairs.empty?
        return 0
      end

      # TODO: consider cases when there are more than one sink pairs to sink
      start_points = []
      # sink_pairs
      # sink pair

      table.calculate_across_all_points!(table.unsunk_ships, 0) do
        table.unsunk_ships.each do |ship|
          if ship.sinkable?(sink_point) && ship.length == sink_ship_length
            start_points << ship.starting_point
          end
        end
      end

      start_points.uniq
      count
      # TODO: out of all the possible matches,
    end

    def ambiguous?
      @tables_generator.num_times_matching_sink_pair > 1
    end
  end
end
