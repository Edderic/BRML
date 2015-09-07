module Battleship
  class Points
    include Enumerable
    def initialize(*args)
      @points = args
    end

    def each(&block)
      @points.each do |point|
        block.call(point)
      end
    end

    def <<(point)
      @points << point
    end

    def uniq
      inject([]) do |accum, point|
        if accum.any? {|pt| pt.same_as?(point) }
          accum
        else
          accum << point
        end

        accum
      end
    end

    def method_missing(m, *args, &block)
      @points.send(m, &block)
    end
  end
end
