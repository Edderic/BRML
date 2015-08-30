require 'spec_helper'

describe Battleship::Table do
  describe '#rows' do
    it 'should return the rows' do
      ships = []
      misses = []
      hash = {row_length: 2, col_length: 1, ships: ships, misses: misses}
      table = Battleship::Table.new(hash)
      table.recreate!
      expect(table.rows[0][0].row).to eq 1
      expect(table.rows[0][0].col).to eq 1

      expect(table.rows[1][0].row).to eq 2
      expect(table.rows[1][0].col).to eq 1
    end
  end

  describe '#point_at' do
    it 'returns an off-the-table point if point is not on the table' do
      ships = []
      misses = []
      hash = {col_length: 10, row_length: 1, ships: ships, misses: misses}
      table = Battleship::Table.new(hash)
      off_table_point = table.point_at(10,10)

      expect(off_table_point).to be_off_table
    end
  end

  # describe '#' do
  # end

  describe '#rel_freqs' do
    describe 'table is 1x3' do
      describe '1 ship of length 3' do
        it 'should return [1,1,1]' do
          ship = Battleship::HorizontalShip.new(length: 3)
          ships = [ship]
          table = Battleship::Table.new(row_length: 1,
                                        col_length: 3,
                                        misses: [],
                                        ships: ships)
          expect(table.rel_freqs.first).to eq [1,1,1]
        end
      end
    end

    describe 'table is 1x4' do
      describe '1 ship of length 3' do
        it 'should return [0.5, 1, 1, 0.5]' do
          ship = Battleship::HorizontalShip.new(length: 3)
          ships = [ship]
          table = Battleship::Table.new(row_length: 1,
                                        col_length: 4,
                                        misses: [],
                                        ships: ships)
          expect(table.rel_freqs.first).to eq [0.5,1,1,0.5]
        end
      end
    end
  end

  describe '#abs_freq!' do
    describe '1x6 board' do
      describe '3 ships of length 2' do
        it 'should give each point an absolute freq of 6' do
          misses = []
          first_ship_length_2 = Battleship::HorizontalShip.new(length: 2)
          second_ship_length_2 = Battleship::HorizontalShip.new(length: 2)
          third_ship_length_2 = Battleship::HorizontalShip.new(length: 2)

          ships = [first_ship_length_2, second_ship_length_2, third_ship_length_2]
          hash = {col_length: 6, row_length: 1, ships: ships, misses: misses}

          table = Battleship::Table.new(hash)
          table.abs_freq!

          first_row_abs_freqs = table.abs_freqs.first
          expect(first_row_abs_freqs).to eq [6,6,6,6,6,6]
        end
      end
    end

    describe '1x10 board' do
      describe '3-length ship is on (1,1), (1,2), and (1,3)' do
        describe '2-length ship is on (1,6) and (1,7)' do
          it 'instantly has [1,2,3,3,3,3,3,3,2,1] of absolute frequencies' do
            misses = []
            ship_length_2 = Battleship::HorizontalShip.new(length: 2)
            ship_length_3 = Battleship::HorizontalShip.new(length: 3)
            ships = [ship_length_2, ship_length_3]
            hash = {col_length: 10, row_length: 1, ships: ships, misses: misses}

            table = Battleship::Table.new(hash)
            table.abs_freq!

            first_row_abs_freqs = table.abs_freqs.first
            expect(first_row_abs_freqs).to eq [12, 22, 25, 23, 23, 23, 23, 25, 22, 12]
          end

          describe 'user hits (1,6)' do
            it 'should give us the proper absolute frequencies' do
              misses = []
              hit_1_6 = Battleship::Point.new(row: 1, col: 6, state: :hit)

              hits = [hit_1_6]
              ship_length_2 = Battleship::HorizontalShip.new(length: 2)
              ship_length_3 = Battleship::HorizontalShip.new(length: 3)
              ships = [ship_length_2, ship_length_3]
              hash = {col_length: 10, row_length: 1, ships: ships, misses: misses, hits: hits}

              table = Battleship::Table.new(hash)
              table.abs_freq!

              first_row_abs_freqs = table.abs_freqs.first
              expect(first_row_abs_freqs).to eq [5,10,10,11,16,23,16,11,8,5]
            end
          end
        end
      end
    end

  end

  describe '#unsunk_ships' do
    describe 'when there are unsunk ships' do
      it 'returns the unsunk ships' do
        misses = []
        hit_1_6 = Battleship::Point.new(row: 1, col: 6, state: :hit)
        hit_1_7 = Battleship::Point.new(row: 1, col: 7, state: :hit)

        hits = [hit_1_6, hit_1_7]

        ship_length_2 = Battleship::HorizontalShip.new(length: 2)
        ship_length_3 = Battleship::HorizontalShip.new(length: 3)

        ship_length_2.sink!

        ships = [ship_length_2, ship_length_3]

        hash = {col_length: 10, row_length: 1, ships: ships, misses: misses, hits: hits}

        table = Battleship::Table.new(hash)
        expect(table.unsunk_ships).not_to include(ship_length_2)
        expect(table.unsunk_ships).to include(ship_length_3)
      end
    end
  end
end
