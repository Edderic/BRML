require 'spec_helper'

describe Battleship::TablesGenerator do
  describe '#unsunk_ships' do
    it 'returns the unsunk ships' do
      unsunk_ships = double('unsunk_ships')
      tables_generator = Battleship::TablesGenerator.new(unsunk_ships: unsunk_ships)
      expect(tables_generator.unsunk_ships).to eq unsunk_ships
    end

    it 'returns empty array if there are none passed' do
      tables_generator = Battleship::TablesGenerator.new({})
      expect(tables_generator.unsunk_ships).to be_empty
    end
  end

  describe '#misses' do
    it 'returns the misses ships' do
      misses = double('misses')
      tables_generator = Battleship::TablesGenerator.new(misses: misses)
      expect(tables_generator.misses).to eq misses
    end

    it 'returns empty array if there are none passed' do
      tables_generator = Battleship::TablesGenerator.new({})
      expect(tables_generator.misses).to be_empty
    end
  end

  describe '#hits' do
    it 'returns the hits ships' do
      hits = double('hits')
      tables_generator = Battleship::TablesGenerator.new(hits: hits)
      expect(tables_generator.hits).to eq hits
    end

    it 'returns empty array if there are none passed' do
      tables_generator = Battleship::TablesGenerator.new({})
      expect(tables_generator.hits).to be_empty
    end
  end

  describe '#sunk_pairs' do
    it 'returns the sunk_pairs ships' do
      sunk_pairs = double('sunk_pairs')
      tables_generator = Battleship::TablesGenerator.new(sunk_pairs: sunk_pairs)
      expect(tables_generator.sunk_pairs).to eq sunk_pairs
    end

    it 'returns empty array if there are none passed' do
      tables_generator = Battleship::TablesGenerator.new({})
      expect(tables_generator.sunk_pairs).to be_empty
    end
  end
  describe '#unsunk_ships_combinations' do
    describe 'when there is one horizontal ship of length 2' do
      it 'should only generate one combination' do
        unsunk_ship_1 = Battleship::HorizontalShip.new(length: 2)
        unsunk_ships = [unsunk_ship_1]
        tables_generator = Battleship::TablesGenerator.new(unsunk_ships: unsunk_ships)

        expect(tables_generator.unsunk_ships_combinations.first).to eq unsunk_ship_1
      end
    end

    describe 'when there is one ship of length 2 and unspecified orientation' do
      it 'should generate two combinations' do
        unsunk_ship_1 = Battleship::Ship.new(length: 2)
        unsunk_ships = [unsunk_ship_1]
        tables_generator = Battleship::TablesGenerator.new(unsunk_ships: unsunk_ships)

# comb = tables_generator.unsunk_ships_combinations
        first_combination = tables_generator.unsunk_ships_combinations.first
        second_combination = tables_generator.unsunk_ships_combinations[1]

        expect(tables_generator.unsunk_ships_combinations.count).to eq 2
        # require 'byebug'; byebug
        expect(first_combination.count).to eq 1
        expect(first_combination[0].class).to eq Battleship::HorizontalShip
        expect(second_combination.count).to eq 1
        expect(second_combination[0].class).to eq Battleship::VerticalShip
      end
    end

    describe 'when there are two ships of unspecified orientation' do
      it 'should generate four combinations [H_x,H_y], [H_x, V_y], [V_x, H_y], [V_x, V_y]' do
        unsunk_ship_1 = Battleship::Ship.new(length: 2)
        unsunk_ship_2 = Battleship::Ship.new(length: 3)
        unsunk_ships = [unsunk_ship_1, unsunk_ship_2]
        tables_generator = Battleship::TablesGenerator.new(unsunk_ships: unsunk_ships)

# comb = tables_generator.unsunk_ships_combinations
        combinations = tables_generator.unsunk_ships_combinations
        first_combination = combinations.first
        second_combination = combinations[1]
        third_combination = combinations[2]
        fourth_combination = combinations[3]

        expect(combinations.length).to eq 4
        # require 'byebug'; byebug
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
