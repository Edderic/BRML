require 'spec_helper'

describe AdjacencyMatrix do
  describe '#connected_components' do
    describe 'with one set of connected components' do
      it 'should return an array of one array' do
        matrix = [
          [0, 1, 1, 0],
          [1, 0, 1, 1],
          [1, 1, 0, 1],
          [0, 1, 1, 0],
        ]

        adjacency_matrix = AdjacencyMatrix.new(matrix)
        expect( adjacency_matrix.connected_components).to eq [[0,1,2,3]]
      end
    end

    describe 'with two sets of connected components' do
      it 'should return an array of two arrays' do
        matrix = [
          [0, 1, 1, 0, 0, 0],
          [1, 0, 1, 1, 0, 0],
          [1, 1, 0, 1, 0, 0],
          [0, 1, 1, 0, 0, 0],
          [0, 0, 0, 0, 0, 1],
          [0, 0, 0, 0, 1, 0],
        ]

        adjacency_matrix = AdjacencyMatrix.new(matrix)
        expect(adjacency_matrix.connected_components).to eq [[0,1,2,3], [4,5]]
      end
    end
  end
end
