require 'spec_helper'

describe Battleship::TablesGenerator do
  describe 'ambiguous sinking' do

    # -------
    # |x|s|x| ambiguous if length 2, unambiguous if length 3
    # -------
    # | | | |
    # -------
    # | | | |
    # -------
    #
    #
    # -------  -------  -------  -------
    # |a|b|b|  |b|a|a|  |a|a|b|  |b|b|a|
    # -------  -------  -------  -------
    # |a| | |  |b| | |  | | |b|  | | |a|
    # -------  -------  -------  -------
    # | | | |  | | | |  | | | |  | | | |
    # -------  -------  -------  -------
    #
    #
    describe '1 ship of length 2' do
      describe 'hits: [(1,1)]' do
        it 'should have abs freqs of [[0,1,0],[1,0,0],[0,0,0]]' do
          ship_1 = Battleship::Ship.new(length: 2)
          hit_1 = Battleship::Point.new(row: 1, col: 1)
          sink_point = Battleship::Point.new(row: 1, col: 2)
          ships = [ship_1]
          hits = [hit_1]
          tables_generator = Battleship::TablesGenerator.new(ships: ships,
                                                             hits: hits,
                                                             sink_pairs: [],
                                                             row_length: 3,
                                                             col_length: 3)
          abs_freqs = tables_generator.abs_freqs

          expect(abs_freqs).to eq [[0,1,0],[1,0,0],[0,0,0]]
        end
      end

      describe 'sink at (1,2)' do
        it 'should give us all zeros as abs freqs' do
          ship_1 = Battleship::Ship.new(length: 2)
          hit_1 = Battleship::Point.new(row: 1, col: 1)
          sink_point = Battleship::Point.new(row: 1, col: 2)
          ships = [ship_1]
          hits = [hit_1]
          sink_pair = Battleship::SinkPair.new(point: sink_point,
                                               ship_length: 2)
          sink_pairs = [sink_pair]
          tables_generator = Battleship::TablesGenerator.new(ships: ships,
                                                             hits: hits,
                                                             sink_pairs: sink_pairs,
                                                             row_length: 3,
                                                             col_length: 3)
          abs_freqs = tables_generator.abs_freqs

          expect(abs_freqs).to eq [[0,0,0],[0,0,0],[0,0,0]]
        end
      end
    end

    describe '2 ships of length 2' do
      describe 'hits: [(1,1), (2,2)]' do
        it 'should have abs freqs of [[0,8,0], [8,0,4], [0,4,0]]' do
          ship_1 = Battleship::Ship.new(length: 2)
          ship_2 = Battleship::Ship.new(length: 2)
          hit_1 = Battleship::Point.new(row: 1, col: 1)
          hit_2 = Battleship::Point.new(row: 2, col: 2)
          # sink_point = Battleship::Point.new(row: 1, col: 2)
          ships = [ship_1, ship_2]
          hits = [hit_1, hit_2]
          tables_generator = Battleship::TablesGenerator.new(ships: ships,
                                                             hits: hits,
                                                             sink_pairs: [],
                                                             row_length: 3,
                                                             col_length: 3)
          abs_freqs = tables_generator.abs_freqs

          expect(abs_freqs).to eq [[0,8,0], [8,0,4], [0,4,0]]
          expect(tables_generator.num_total_configurations).to eq 12
        end

        describe 'sink length 2 at (1,2)' do
          it 'should give us [[0,0,0], [2,0,1], [0,2,0]]' do
            ship_1 = Battleship::Ship.new(length: 2)
            ship_2 = Battleship::Ship.new(length: 2)
            hit_1 = Battleship::Point.new(row: 1, col: 1)
            hit_2 = Battleship::Point.new(row: 2, col: 2)
            sink_point = Battleship::Point.new(row: 1, col: 2)
            ships = [ship_1, ship_2]
            hits = [hit_1, hit_2]
            sink_pair = Battleship::SinkPair.new(point: sink_point,
                                                 ship_length: 2)
            sink_pairs = [sink_pair]
            tables_generator = Battleship::TablesGenerator.new(ships: ships,
                                                               hits: hits,
                                                               sink_pairs: sink_pairs,
                                                               row_length: 3,
                                                               col_length: 3)
            abs_freqs = tables_generator.abs_freqs

            expect(abs_freqs).to eq [[0,0,0], [2,0,1], [0,2,0]]
            expect(tables_generator.num_total_configurations).to eq 5
            expect(tables_generator.best_targets.count).to eq 2
            expect(tables_generator.best_targets.any? do |pt|
              pt.has_coords?(2,1)
            end).to eq true

            expect(tables_generator.best_targets.any? do |pt|
              pt.has_coords?(3,2)
            end).to eq true
          end

          describe 'misses at (2,3)' do
            it 'should give us [[0,0,0], [2,0,0], [0,2,0]]' do
              ship_1 = Battleship::Ship.new(length: 2)
              ship_2 = Battleship::Ship.new(length: 2)
              hit_1 = Battleship::Point.new(row: 1, col: 1)
              hit_2 = Battleship::Point.new(row: 2, col: 2)
              miss_1 = Battleship::Point.new(row: 2, col: 3)
              sink_point = Battleship::Point.new(row: 1, col: 2)
              ships = [ship_1, ship_2]
              hits = [hit_1, hit_2]
              misses = [miss_1]
              sink_pair = Battleship::SinkPair.new(point: sink_point,
                                                   ship_length: 2)
              sink_pairs = [sink_pair]
              tables_generator = Battleship::TablesGenerator.new(ships: ships,
                                                                 hits: hits,
                                                                 misses: misses,
                                                                 sink_pairs: sink_pairs,
                                                                 row_length: 3,
                                                                 col_length: 3)
              abs_freqs = tables_generator.abs_freqs

              expect(abs_freqs).to eq [[0,0,0], [2,0,0], [0,2,0]]
              expect(tables_generator.num_total_configurations).to eq 4
            end

            describe 'misses at (3,2)' do
              it 'should give us [[0,0,0], [2,0,0], [0,0,0]]' do
                ship_1 = Battleship::Ship.new(length: 2)
                ship_2 = Battleship::Ship.new(length: 2)
                hit_1 = Battleship::Point.new(row: 1, col: 1)
                hit_2 = Battleship::Point.new(row: 2, col: 2)
                miss_1 = Battleship::Point.new(row: 2, col: 3)
                miss_2 = Battleship::Point.new(row: 3, col: 2)
                sink_point = Battleship::Point.new(row: 1, col: 2)
                ships = [ship_1, ship_2]
                hits = [hit_1, hit_2]
                misses = [miss_1, miss_2]
                sink_pair = Battleship::SinkPair.new(point: sink_point,
                                                     ship_length: 2)
                sink_pairs = [sink_pair]
                tables_generator = Battleship::TablesGenerator.new(ships: ships,
                                                                   hits: hits,
                                                                   misses: misses,
                                                                   sink_pairs: sink_pairs,
                                                                   row_length: 3,
                                                                   col_length: 3)
                abs_freqs = tables_generator.abs_freqs

                expect(abs_freqs).to eq [[0,0,0], [2,0,0], [0,0,0]]
                expect(tables_generator.num_total_configurations).to eq 2
              end
            end
          end
        end
      end
    end

    describe '2 ships of length 2, hits:[(1,1), (1,3)], sink_pair: [sink_point(1,2), length:2]' do
      it 'should give [[0,0,0],[2,0,2],[0,0,0]]' do

        ship_1 = Battleship::Ship.new(length: 2)
        ship_2 = Battleship::Ship.new(length: 2)
        hit_1 = Battleship::Point.new(row: 1, col: 1)
        hit_2 = Battleship::Point.new(row: 1, col: 3)
        sink_point = Battleship::Point.new(row: 1, col: 2)
        ships = [ship_1, ship_2]
        hits = [hit_1, hit_2]
        sink_pair = Battleship::SinkPair.new(point: sink_point,
                                             ship_length: 2)
        sink_pairs = [sink_pair]
        tables_generator = Battleship::TablesGenerator.new(ships: ships,
                                                           hits: hits,
                                                           sink_pairs: sink_pairs,
                                                           row_length: 3,
                                                           col_length: 3)
        abs_freqs = tables_generator.abs_freqs

        expect(abs_freqs).to eq [[0,0,0],[2,0,2],[0,0,0]]
        expect(tables_generator.num_total_configurations).to eq 4
      end
    end

    describe 'sink length 2 at (1,3)' do
      it 'should give [[0,0,0],[0,0,0],[0,0,0]]' do
        ship_1 = Battleship::Ship.new(length: 2)
        ship_2 = Battleship::Ship.new(length: 2)
        hit_1 = Battleship::Point.new(row: 1, col: 1)
        hit_2 = Battleship::Point.new(row: 1, col: 3)
        sink_point_1 = Battleship::Point.new(row: 1, col: 2)
        sink_point_2 = Battleship::Point.new(row: 3, col: 2)
        ships = [ship_1, ship_2]
        hits = [hit_1, hit_2]
        sink_pair_1 = Battleship::SinkPair.new(point: sink_point_1,
                                               ship_length: 2)
        sink_pair_2 = Battleship::SinkPair.new(point: sink_point_2,
                                               ship_length: 2)
        sink_pairs = [sink_pair_1, sink_pair_2]
        tables_generator = Battleship::TablesGenerator.new(ships: ships,
                                                           hits: hits,
                                                           sink_pairs: sink_pairs,
                                                           row_length: 3,
                                                           col_length: 3)
        abs_freqs = tables_generator.abs_freqs

        expect(abs_freqs).to eq [[0,0,0],[0,0,0],[0,0,0]]
      end
    end
  end

  describe 'unambiguous positioning of sink ships' do
    it 'all abs freqs should be 0' do
      ship_1 = Battleship::Ship.new(length: 2)
      hit_1 = Battleship::Point.new(row: 1, col: 1)
      sink_point = Battleship::Point.new(row: 2, col: 1)
      ships = [ship_1]
      hits = [hit_1]
      sink_pair = Battleship::SinkPair.new(point: sink_point,
                                           ship_length: 2)
      sink_pairs = [sink_pair]
      tables_generator = Battleship::TablesGenerator.new(ships: ships,
                                                         hits: hits,
                                                         sink_pairs: sink_pairs,
                                                         row_length: 3,
                                                         col_length: 3)

      abs_freqs = tables_generator.abs_freqs
      expect(abs_freqs).to eq [[0,0,0],[0,0,0],[0,0,0]]
      expect(tables_generator.num_total_configurations).to eq 0
    end
  end

  describe 'ship of length 2 in 3x3' do
    it 'abs_freqs should return the proper freqs' do
      ship_1 = Battleship::Ship.new(length: 2)
      ships = [ship_1]
      tables_generator = Battleship::TablesGenerator.new(ships: ships,
                                                         row_length: 3,
                                                         col_length: 3)

      abs_freqs = tables_generator.abs_freqs
      expect(abs_freqs).to eq [[2,3,2],[3,4,3],[2,3,2]]
      expect(tables_generator.num_total_configurations).to eq 12
    end

    describe 'user hits top corner' do
      it 'should calculate the right absolute frequencies' do
        ship_1 = Battleship::Ship.new(length: 2)
        hit_1 = Battleship::Point.new(row: 1, col: 1)
        ships = [ship_1]
        hits = [hit_1]
        tables_generator = Battleship::TablesGenerator.new(ships: ships,
                                                           hits: hits,
                                                           row_length: 3,
                                                           col_length: 3)

        abs_freqs = tables_generator.abs_freqs
        expect(abs_freqs).to eq [[0,1,0],[1,0,0],[0,0,0]]
        expect(tables_generator.num_total_configurations).to eq 2
      end

      describe 'user sinks the ship at (1,2)' do
        it 'all abs freqs should be 0' do

          ship_1 = Battleship::Ship.new(length: 2)
          hit_1 = Battleship::Point.new(row: 1, col: 1)
          sink_point = Battleship::Point.new(row: 1, col: 2)
          ships = [ship_1]
          hits = [hit_1]
          sink_pair = Battleship::SinkPair.new(point: sink_point,
                                               ship_length: 2)
          sink_pairs = [sink_pair]
          tables_generator = Battleship::TablesGenerator.new(ships: ships,
                                                             hits: hits,
                                                             sink_pairs: sink_pairs,
                                                             row_length: 3,
                                                             col_length: 3)

          abs_freqs = tables_generator.abs_freqs
          expect(abs_freqs).to eq [[0,0,0],[0,0,0],[0,0,0]]
          expect(tables_generator.num_total_configurations).to eq 0
        end
      end
    end
  end

  describe '#ships_combinations' do
    describe 'when there is one horizontal ship of length 2' do
      it 'should only generate one combination' do
        ship_1 = Battleship::HorizontalShip.new(length: 2)
        ships = [ship_1]
        tables_generator = Battleship::TablesGenerator.new(ships: ships,
                                                           row_length: 3,
                                                           col_length: 3)

        expect(tables_generator.ships_combinations.first.first.class).to eq Battleship::HorizontalShip
      end
    end

    describe 'when there is one ship of length 2 and unspecified orientation' do
      it 'should generate two combinations' do
        ship_1 = Battleship::Ship.new(length: 2)
        ships = [ship_1]
        tables_generator = Battleship::TablesGenerator.new(ships: ships,
                                                           row_length: 2,
                                                           col_length: 2)

        first_combination = tables_generator.ships_combinations.first
        second_combination = tables_generator.ships_combinations[1]

        expect(tables_generator.ships_combinations.count).to eq 2
        expect(first_combination.count).to eq 1
        expect(first_combination[0].class).to eq Battleship::HorizontalShip
        expect(second_combination.count).to eq 1
        expect(second_combination[0].class).to eq Battleship::VerticalShip
      end
    end

    describe 'when there are two ships of unspecified orientation' do
      it 'should generate four combinations [H_x,H_y], [H_x, V_y], [V_x, H_y], [V_x, V_y]' do
        ship_1 = Battleship::Ship.new(length: 2)
        ship_2 = Battleship::Ship.new(length: 3)
        ships = [ship_1, ship_2]
        tables_generator = Battleship::TablesGenerator.new(ships: ships,
                                                           row_length: 3,
                                                           col_length: 3)

        combinations = tables_generator.ships_combinations
        first_combination = combinations.first
        second_combination = combinations[1]
        third_combination = combinations[2]
        fourth_combination = combinations[3]

        expect(combinations.length).to eq 4
        expect(first_combination.count).to eq 2
        expect(first_combination[0].class).to eq Battleship::HorizontalShip
        expect(first_combination[0].length).to eq 2
        expect(first_combination[1].class).to eq Battleship::HorizontalShip
        expect(first_combination[1].length).to eq 3

        expect(second_combination.count).to eq 2
        expect(second_combination[0].class).to eq Battleship::HorizontalShip
        expect(second_combination[0].length).to eq 2
        expect(second_combination[1].class).to eq Battleship::VerticalShip
        expect(second_combination[1].length).to eq 3

        expect(third_combination.count).to eq 2
        expect(third_combination[0].class).to eq Battleship::VerticalShip
        expect(third_combination[0].length).to eq 2
        expect(third_combination[1].class).to eq Battleship::HorizontalShip
        expect(third_combination[1].length).to eq 3

        expect(fourth_combination.count).to eq 2
        expect(fourth_combination[0].class).to eq Battleship::VerticalShip
        expect(fourth_combination[0].length).to eq 2
        expect(fourth_combination[1].class).to eq Battleship::VerticalShip
        expect(fourth_combination[1].length).to eq 3
      end
    end
  end
end
