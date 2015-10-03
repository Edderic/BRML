class AdjacencyMatrix
  def initialize(matrix)
    @matrix = matrix
  end

  def connected_components
    ConnectedComponentsCalculator.new(@matrix).connected_components
  end


  class ConnectedComponentsCalculator
    def initialize(matrix)
      @matrix = matrix
    end

    def connected_components
      components = []
      @matrix.each_with_index do |row, row_index|
        adj_nodes_of_row = adjacent_nodes_of_row(row)
        adj_nodes_of_row << row_index

        matches = components_with_matches(components, adj_nodes_of_row)

        if matches.empty?
          components << adj_nodes_of_row
        else
          reject_duplicates(components, matches, adj_nodes_of_row)
          components << union_component(matches, adj_nodes_of_row)
        end
      end

      components.map { |component| component.sort! }
    end

    def reject_duplicates(components, matches, adj_nodes_of_row)
      components.reject! do |component|
        component.any? do |component_node_index|
          union_component(matches, adj_nodes_of_row).any? do |value|
            value == component_node_index
          end
        end
      end
    end

    def union_component(matches, adj_nodes_of_row)
      matches.inject {|accum,match| accum | match} | adj_nodes_of_row
    end

    def components_with_matches(components, adjacent_nodes)
      components.select do |component|
        component.any? do |component_node_index|
          adjacent_nodes.any? do |node_index|
            component_node_index == node_index
          end
        end
      end
    end

    def adjacent_nodes_of_row(row)
      row.each.with_index.inject([]) do |indices, (val, index)|
        val == 1 ? indices << index : indices
      end
    end
  end
end
