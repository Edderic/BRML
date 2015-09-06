# sinking should be the SinkPair's job
# SinkPair#sink! would sink the sunk point and the other associated sink points it is not ambiguous. If ambiguous, we mark the sink point as "sunk", but we do not sink the other associated points.

module Battleship
  class SinkPair
    attr_accessor :tables_generator
    attr_reader :sink_point, :sink_ship_length
    def initialize(args)
      @sink_point = args.fetch(:point)
      @sink_ship_length = args.fetch(:ship_length)
    end

    def ambiguous?
      @tables_generator.num_times_matching_sink_pair > 1
    end
  end
end
