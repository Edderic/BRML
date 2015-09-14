require 'spec_helper'

describe Battleship::SinkPair do
  describe '#abs_freqable?' do
    describe 'hits:[(1,1), (1,3)], sink_pair: [sink_point(1,2), length:2]' do
      describe '2 vertical ships of length 2, ' do
        it 'should give [[0,0,0],[0,0,0],[0,0,0]]' do

          ship_1 = Battleship::VerticalShip.new(length: 2)
          ship_2 = Battleship::VerticalShip.new(length: 2)
          hit_1 = Battleship::Point.new(row: 1, col: 1)
          hit_2 = Battleship::Point.new(row: 1, col: 3)
          sink_point = Battleship::Point.new(row: 1, col: 2)
          ships = [ship_1, ship_2]
          hits = [hit_1, hit_2]
          sink_pair = Battleship::SinkPair.new(point: sink_point,
                                               ship_length: 2)
          sink_pairs = [sink_pair]
          table = Battleship::Table.new(ships: ships,
                                        hits: hits,
                                        sink_pairs: sink_pairs,
                                        row_length: 3,
                                        col_length: 3)
          sink_pair.sink!
          abs_freqs = table.abs_freqs

          expect(abs_freqs).to eq [[0,0,0],[0,0,0],[0,0,0]]
          expect(table.num_total_configurations).to eq 0
        end
      end

      describe '1 horizontal ship and 1 vertical ship of length 2' do
        it 'should give us [[0,0,0], [1,0,1], [0,0,0] ]' do
          ship_1 = Battleship::HorizontalShip.new(length: 2)
          ship_2 = Battleship::VerticalShip.new(length: 2)
          hit_1 = Battleship::Point.new(row: 1, col: 1)
          hit_2 = Battleship::Point.new(row: 1, col: 3)
          sink_point = Battleship::Point.new(row: 1, col: 2)
          ships = [ship_1, ship_2]
          hits = [hit_1, hit_2]
          sink_pair = Battleship::SinkPair.new(point: sink_point,
                                               ship_length: 2)
          sink_pairs = [sink_pair]
          table = Battleship::Table.new(ships: ships,
                                        hits: hits,
                                        sink_pairs: sink_pairs,
                                        row_length: 3,
                                        col_length: 3)
          sink_pair.sink!
          table.abs_freq!
          abs_freqs = table.abs_freqs

          expect(abs_freqs).to eq [[0,0,0],[1,0,1],[0,0,0]]
          expect(table.num_total_configurations).to eq 2
        end
      end
    end
  end
  describe 'with a table' do
    describe '#valid?' do
      it 'returns true if the ship covers the sink point and the remaining occupied point of the ship are hit' do
        ship_1 = Battleship::HorizontalShip.new(length: 2)
        ships = [ship_1]
        hit_1_5 = Battleship::Point.new(row: 1, col: 5)
        hits = [hit_1_5]
        sink_1_6 = Battleship::Point.new(row: 1, col: 6)
        sink_pair = Battleship::SinkPair.new(point: sink_1_6,
                                             ship_length: 2)

        sink_pairs = [sink_pair]
        table = Battleship::Table.new(col_length: 10,
                                      row_length: 1,
                                      ships: ships,
                                      sink_pairs: sink_pairs,
                                      hits: hits)
        ship_1.start_at(hit_1_5)
        expect(sink_pair).to be_valid
      end

      it 'returns false if the ship does not cover it' do
        ship_1 = Battleship::HorizontalShip.new(length: 2)
        ships = [ship_1]
        point_1_4 = Battleship::Point.new(row: 1, col: 4)
        hits = []
        sink_1_6 = Battleship::Point.new(row: 1, col: 6)
        sink_pair = Battleship::SinkPair.new(point: sink_1_6,
                                             ship_length: 2)

        sink_pairs = [sink_pair]
        table = Battleship::Table.new(col_length: 10,
                                      row_length: 1,
                                      ships: ships,
                                      sink_pairs: sink_pairs,
                                      hits: hits)
        ship_1.start_at(point_1_4)
        expect(sink_pair).not_to be_valid
      end
    end

    describe '#sink!' do
      # describe 'when sink point configuration is ambiguous' do
      # it 'should sink the ship' do
      # end
      #
      # it 'kk' do
      # end
      # end

      describe 'when sink point configuration is unambiguous' do
        describe 'when ship length matches more than one ship' do
          it 'should only sink one' do
            ship_1 = Battleship::HorizontalShip.new(length: 2)
            ship_2 = Battleship::HorizontalShip.new(length: 2)
            ships = [ship_1, ship_2]
            point_1_1 = Battleship::Point.new(row: 1, col: 1)
            point_1_5 = Battleship::Point.new(row: 1, col: 5)
            hits = [point_1_1,point_1_5]
            sink_1_6 = Battleship::Point.new(row: 1, col: 6)
            sink_pair = Battleship::SinkPair.new(point: sink_1_6,
                                                 ship_length: 2)

            sink_pairs = [sink_pair]
            table = Battleship::Table.new(col_length: 10,
                                          row_length: 1,
                                          ships: ships,
                                          sink_pairs: sink_pairs,
                                          hits: hits)

            sink_pair.sink!
            expect(table.point_at(point_1_5)).to be_sunk
            expect(table.point_at(sink_1_6)).to be_sunk
            expect(table.fully_sunk_ships.count).to eq 1
            expect(table.unsunk_ships.count).to eq 1
          end
        end

        describe 'it should save the sink pair for later processing' do
        end
      end

      describe 'if successful' do
        it 'should be fully sunk' do
          ship_1 = Battleship::HorizontalShip.new(length: 3)
          ship_2 = Battleship::HorizontalShip.new(length: 2)
          hit_1_5 = Battleship::Point.new(row: 1, col: 5)
          sink_1_6 = Battleship::Point.new(row: 1, col: 6)
          sink_pair = Battleship::SinkPair.new(point: sink_1_6,
                                               ship_length: 2)
          sink_pairs = [sink_pair]
          ships = [ship_1, ship_2]
          hits = [hit_1_5]
          table = Battleship::Table.new(col_length: 10,
                                        row_length: 1,
                                        ships: ships,
                                        hits: hits,
                                        sink_pairs: sink_pairs)
          sink_pair.sink!

          expect(sink_pair).to be_fully_sunk
        end
      end

      describe 'if not successful' do
        it 'should be partially sunk' do
          ship_1 = Battleship::HorizontalShip.new(length: 3)
          ship_2 = Battleship::HorizontalShip.new(length: 2)
          hit_1_5 = Battleship::Point.new(row: 1, col: 5)
          hit_1_7 = Battleship::Point.new(row: 1, col: 7)
          sink_1_6 = Battleship::Point.new(row: 1, col: 6)
          sink_pair = Battleship::SinkPair.new(point: sink_1_6,
                                               ship_length: 2)
          sink_pairs = [sink_pair]
          ships = [ship_1, ship_2]
          hits = [hit_1_5, hit_1_7]
          table = Battleship::Table.new(col_length: 10,
                                        row_length: 1,
                                        ships: ships,
                                        hits: hits,
                                        sink_pairs: sink_pairs)
          sink_pair.sink!

          expect(sink_pair).not_to be_fully_sunk
        end
      end
    end
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
end
