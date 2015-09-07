require 'spec_helper'

describe Battleship::SinkPair do
  describe 'with a table' do
    describe '#num_times_matching_sink_pair' do
      describe 'when there are two ships of the same length' do
        describe 'and both ships satisfies the length constraint' do
          it 'should return 1' do
            hit_1_6 = Battleship::Point.new(row: 1, col: 6, state: :hit)
            hit_1_7 = Battleship::Point.new(row: 1, col: 7)

            hits = [hit_1_6]
            ship_length_2 = Battleship::HorizontalShip.new(length: 2)
            another_ship_length_2 = Battleship::HorizontalShip.new(length: 2)
            ships = [ship_length_2, another_ship_length_2]
            sink_pair = Battleship::SinkPair.new(ship_length:2,
                                                 point: hit_1_7)
            sink_pairs = [sink_pair]
            hash = {col_length: 10,
                    row_length: 1,
                    ships: ships,
                    sink_pairs: sink_pairs,
                    hits: hits}

            table = Battleship::Table.new(hash)
            # a Table should know about sink pairs, so that we can
            # figure out what sinking should be done.
            # However...
            # sinking should be deferred to some other object later
            # table.sink!(hit_1_7, 2)

            expect(sink_pair.num_times_matching_sink_pair).to eq 1
          end
        end
      end

      describe 'when the setup is not ambiguous' do
        it 'should return 1' do
          hit_1_6 = Battleship::Point.new(row: 1, col: 6, state: :hit)
          hit_1_7 = Battleship::Point.new(row: 1, col: 7)

          hits = [hit_1_6]
          ship_length_2 = Battleship::HorizontalShip.new(length: 2)
          ship_length_3 = Battleship::HorizontalShip.new(length: 3)
          ships = [ship_length_2, ship_length_3]
          sink_pair = Battleship::SinkPair.new(ship_length:2,
                                               point: hit_1_7)
          sink_pairs = [sink_pair]
          hash = {col_length: 10,
                  row_length: 1,
                  ships: ships,
                  sink_pairs: sink_pairs,
                  hits: hits}

          table = Battleship::Table.new(hash)
          # a Table should know about sink pairs, so that we can
          # figure out what sinking should be done.
          # However...
          # sinking should be deferred to some other object later
          # table.sink!(hit_1_7, 2)

          expect(sink_pair.num_times_matching_sink_pair).to eq 1
        end
      end

      describe 'when the setup is ambiguous' do
        it 'should return more than 1' do
          hit_1_6 = Battleship::Point.new(row: 1, col: 6, state: :hit)
          sink_1_7 = Battleship::Point.new(row: 1, col: 7)
          hit_1_8 = Battleship::Point.new(row: 1, col: 8, state: :hit)

          hits = [hit_1_6, hit_1_8]
          ship_length_2 = Battleship::HorizontalShip.new(length: 2)
          ship_length_3 = Battleship::HorizontalShip.new(length: 3)
          ships = [ship_length_2, ship_length_3]
          sink_pair = Battleship::SinkPair.new(ship_length:2,
                                               point: sink_1_7)
          sink_pairs = [sink_pair]
          hash = {col_length: 10,
                  row_length: 1,
                  ships: ships,
                  sink_pairs: sink_pairs,
                  hits: hits}

          table = Battleship::Table.new(hash)
          # table.sink!(sink_1_7, 2)

          expect(sink_pair.num_times_matching_sink_pair).to eq 2
        end
      end
    end
  end

  describe '#ambiguous?' do
    describe 'when the associated ship can cover the sink point more than one way' do
      it 'should return true' do
        sink_point = Battleship::Point.new(row: 1, col: 1)
        hit_point_1 = Battleship::Point.new(row: 1, col: 2)
        hit_point_2 = Battleship::Point.new(row: 2, col: 1)
        hits = [hit_point_1, hit_point_2]
        unsink_ship = Battleship::Ship.new(length: 2)
        ships = [unsink_ship]
        sink_pair = Battleship::SinkPair.new(point: sink_point, ship_length: 2)
        sink_pairs = [sink_pair]
        tables_generator = Battleship::TablesGenerator.new(row_length: 3,
                                                           col_length: 3,
                                                           sink_pairs: sink_pairs,
                                                           hits: hits,
                                                           ships: ships
                                                          )
        expect(sink_pair).to be_ambiguous
      end
    end

    describe 'when the associated ship has only one way to cover the sink point' do
      it 'should return false' do
        sink_point = Battleship::Point.new(row: 1, col: 1)
        hit_point_1 = Battleship::Point.new(row: 1, col: 2)
        hit_points = [hit_point_1]
        unsink_ship = Battleship::Ship.new(length: 2)
        ships = [unsink_ship]
        sink_pair = Battleship::SinkPair.new(point: sink_point, ship_length: 2)
        sink_pairs = [sink_pair]
        tables_generator = Battleship::TablesGenerator.new(row_length: 3,
                                                           col_length: 3,
                                                           sink_pairs: sink_pairs,
                                                           hit_points: hit_points,
                                                           ships: ships
                                                          )
        expect(sink_pair).not_to be_ambiguous
      end
    end
  end
end
