describe Battleship::NaiveTable do
  describe '#abs_freqs' do

    describe '5x5 bd, HS3, HS3' do
      describe 'hit_1_4, hit_2_4' do
        it 'should return the frequencies' do
          horizontal_ship_1 = Battleship::HorizontalShip.new(length: 3)
          horizontal_ship_2 = Battleship::HorizontalShip.new(length: 3)
          ships = [horizontal_ship_1, horizontal_ship_2]
          hit_1_4 = Battleship::Point.new(row: 1, col: 4)
          hit_2_4 = Battleship::Point.new(row: 2, col: 4)
          hits = [hit_1_4, hit_2_4]
          naive_table = Battleship::NaiveTable.new(ships: ships,
                                                   hits: hits,
                                                   row_length: 5,
                                                   col_length: 5)
          naive_table.abs_freq!
          expect(naive_table.abs_freqs).to eq [
            [0,2,4,0,2],
            [0,2,4,0,2],
            [0,0,0,0,0],
            [0,0,0,0,0],
            [0,0,0,0,0]
          ]

          expect(naive_table.num_total_configurations).to eq 8
        end
      end
    end

    describe '5x5 bd, VS3, VS3' do
      describe 'hit_1_4, hit_2_4' do
        it 'should return the frequencies' do
          vertical_ship_1 = Battleship::VerticalShip.new(length: 3)
          vertical_ship_2 = Battleship::VerticalShip.new(length: 3)
          ships = [vertical_ship_1, vertical_ship_2]
          hit_3_3 = Battleship::Point.new(row: 3, col: 3)
          hit_3_2 = Battleship::Point.new(row: 3, col: 2)
          hits = [hit_3_2, hit_3_3]
          naive_table = Battleship::NaiveTable.new(ships: ships,
                                                   hits: hits,
                                                   row_length: 5,
                                                   col_length: 5)
          naive_table.abs_freq!
          expect(naive_table.abs_freqs).to eq [
            [0,2,2,0,0],
            [0,4,4,0,0],
            [0,0,0,0,0],
            [0,4,4,0,0],
            [0,2,2,0,0],
          ]

          expect(naive_table.num_total_configurations).to eq 12
        end
      end
    end

    describe '5x5 bd, VS3, VS3' do
      describe 'hit_1_4, hit_2_4' do
        it 'should return the frequencies' do
          vertical_ship_1 = Battleship::VerticalShip.new(length: 3)
          vertical_ship_2 = Battleship::VerticalShip.new(length: 3)
          ships = [vertical_ship_1, vertical_ship_2]
          hit_1_4 = Battleship::Point.new(row: 1, col: 4)
          hit_2_4 = Battleship::Point.new(row: 2, col: 4)
          hits = [hit_1_4, hit_2_4]
          naive_table = Battleship::NaiveTable.new(ships: ships,
                                                   hits: hits,
                                                   row_length: 5,
                                                   col_length: 5)
          naive_table.abs_freq!
          expect(naive_table.abs_freqs).to eq [
            [0,0,0,0,0],
            [0,0,0,0,0],
            [0,0,0,4,0],
            [0,0,0,2,0],
            [0,0,0,0,0]
          ]

          expect(naive_table.num_total_configurations).to eq 4
        end
      end
    end



    describe '5x5 bd, VS3, HS3' do
      describe 'hit_1_4, hit_2_4' do
        it 'should return the frequencies' do
          horizontal_ship = Battleship::HorizontalShip.new(length: 3)
          vertical_ship = Battleship::VerticalShip.new(length: 3)
          ships = [horizontal_ship, vertical_ship]
          hit_1_4 = Battleship::Point.new(row: 1, col: 4)
          hit_2_4 = Battleship::Point.new(row: 2, col: 4)
          hits = [hit_1_4, hit_2_4]
          naive_table = Battleship::NaiveTable.new(ships: ships,
                                                   hits: hits,
                                                   row_length: 5,
                                                   col_length: 5)
          naive_table.abs_freq!
          expect(naive_table.abs_freqs).to eq [
            [0,1,2,0,1],
            [0,1,2,0,1],
            [0,0,0,2,0],
            [0,0,0,1,0],
            [0,0,0,0,0]
          ]

          expect(naive_table.num_total_configurations).to eq 6
        end
      end
    end

    describe '5x5 bd, VS3, VS2' do
      it 'should calculate the absolute frequencies' do
        horizontal_ship = Battleship::VerticalShip.new(length: 3)
        vertical_ship = Battleship::VerticalShip.new(length: 2)
        ships = [horizontal_ship, vertical_ship]
        naive_table = Battleship::NaiveTable.new(ships: ships,
                                                 row_length: 5,
                                                 col_length: 5)
        naive_table.abs_freq!
        expect(naive_table.abs_freqs).to eq [
          [2,2,2,2,2],
          [4,4,4,4,4],
          [5,5,5,5,5],
          [4,4,4,4,4],
          [2,2,2,2,2]
        ]
      end
    end

    describe '5x5 bd, VS3, VS2, hit_3_1' do
      it 'should have each ship not care about the placement of other ships' do
        horizontal_ship = Battleship::VerticalShip.new(length: 3)
        vertical_ship = Battleship::VerticalShip.new(length: 2)
        ships = [horizontal_ship, vertical_ship]
        hit_3_1 = Battleship::Point.new(row: 3, col: 1)
        hits = [hit_3_1]
        naive_table = Battleship::NaiveTable.new(ships: ships,
                                                 hits: hits,
                                                 row_length: 5,
                                                 col_length: 5)
        naive_table.abs_freq!
        expect(naive_table.abs_freqs).to eq [
          [1,0,0,0,0],
          [3,0,0,0,0],
          [0,0,0,0,0],
          [3,0,0,0,0],
          [1,0,0,0,0]
        ]
      end
    end

    describe '5x5 bd, VS3, HS2, hit_3_1' do
      it 'should have each ship not care about the placement of other ships' do
        horizontal_ship = Battleship::VerticalShip.new(length: 3)
        vertical_ship = Battleship::HorizontalShip.new(length: 2)
        ships = [horizontal_ship, vertical_ship]
        hit_3_1 = Battleship::Point.new(row: 3, col: 1)
        hits = [hit_3_1]
        naive_table = Battleship::NaiveTable.new(ships: ships,
                                                 hits: hits,
                                                 row_length: 5,
                                                 col_length: 5)
        naive_table.abs_freq!
        expect(naive_table.abs_freqs).to eq [
          [1,0,0,0,0],
          [2,0,0,0,0],
          [0,1,0,0,0],
          [2,0,0,0,0],
          [1,0,0,0,0]
        ]
      end
    end

    describe '5x5 bd, HS3, HS2, hit_3_1' do
      it 'should have each ship not care about the placement of other ships' do
        horizontal_ship = Battleship::HorizontalShip.new(length: 3)
        vertical_ship = Battleship::HorizontalShip.new(length: 2)
        ships = [horizontal_ship, vertical_ship]
        hit_3_1 = Battleship::Point.new(row: 3, col: 1)
        hits = [hit_3_1]
        naive_table = Battleship::NaiveTable.new(ships: ships,
                                                 hits: hits,
                                                 row_length: 5,
                                                 col_length: 5)
        naive_table.abs_freq!
        expect(naive_table.abs_freqs).to eq [
          [0,0,0,0,0],
          [0,0,0,0,0],
          [0,2,1,0,0],
          [0,0,0,0,0],
          [0,0,0,0,0]
        ]
      end
    end

    describe '5x5 bd, HS3, VS2, hit_3_1' do
      it 'should have each ship not care about the placement of other ships' do
        horizontal_ship = Battleship::HorizontalShip.new(length: 3)
        vertical_ship = Battleship::VerticalShip.new(length: 2)
        ships = [horizontal_ship, vertical_ship]
        hit_3_1 = Battleship::Point.new(row: 3, col: 1)
        hits = [hit_3_1]
        naive_table = Battleship::NaiveTable.new(ships: ships,
                                                 hits: hits,
                                                 row_length: 5,
                                                 col_length: 5)
        naive_table.abs_freq!
        expect(naive_table.abs_freqs).to eq [
          [0,0,0,0,0],
          [1,0,0,0,0],
          [0,1,1,0,0],
          [1,0,0,0,0],
          [0,0,0,0,0]
        ]
      end
    end
  end
end
