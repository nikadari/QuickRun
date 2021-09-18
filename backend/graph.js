// Required libraries
var _ = require('underscore');

// Class for graph. Where each index in the matrix also has a
// text representation.
// Ex) index 0 might correspond to A. 1 to B, etc.
class Graph {

  TextToIndex(text) {
    return this.textToIndexMap.get(text);
  }

  IndexToText(index) {
    return this.indexToTextMap.get(index);
  }

  // Returns the weight of the edge, where the edge is defined
  // by the staring node and the ending node, the nodes in
  // text representation.
  GetEdgeWeight(begin_node, end_node) {
    let begin_index = this.TextToIndex(begin_node);
    let end_index = this.TextToIndex(end_node);
    return this.adjacency_matrix[begin_index][end_index];
  }

  // returns the weighted length of the path for this graph.
  // The path is a list of nodes in text representation.
  GetPathLength(path) {
    let path_distance = 0;
    for (let j = 0; j < path.length - 1; j++) {
      let edge_start = path[j];
      let edge_end = path[j + 1];
      path_distance += this.GetEdgeWeight(edge_start, edge_end);
    }
    return path_distance;
  }
}

module.exports = {

  // Recall: How does this algorithm work again?
  // This function will take a starting node on the graph,
  // where the node must be in the text representation.
  // It will run a Djikstra and return an array of paths,
  // where each path is an array of nodes, all in text representation.
  Dijkstra: function (graph, starting_node, unit_test=false) {

    let unvisited_set = [...graph.nodes];
    let distances = [...graph.nodes.map((node) => (Infinity))];

    if (unit_test) {
      console.log("unvisited_set=", unvisited_set);
      console.log("distances=", distances);
    }

    // Initialize the paths structure for return.
    let paths = [];
    for (let i = 0; i < unvisited_set.length; i++)
    {
      //let node = unvisited_set[i];
      paths.push([]);
    }

    // Initialize the algo with the starting node. This is the first node we visit.
    let starting_node_index = graph.TextToIndex(starting_node);
    distances[starting_node_index] = 0;
    let current_node = starting_node;
    paths[starting_node_index] = [current_node];

    // The terminating condition of the search is that there are no more nodes in the unvisited set, or
    // the that smallest distance left is infinity.
    // NOTE: I am not quite sure that this is going to work...
    while( unvisited_set.length > 0 && Math.min(...distances) != Infinity )
    {
      // Look at the current_node
      let current_node_index = graph.TextToIndex(current_node);

      if (unit_test) {
        console.log("current_node=", current_node);
        console.log("distances=", [...distances.map( (distance, index) => {
          return {
            distance,
            node_text: graph.IndexToText(index)
          }
        })]);
      }

      // Find the neighbors
      let connections = graph.adjacency_matrix[current_node_index];
      let neighbors = [];
      for (let i = 0; i < connections.length; i++)
      {
        let connection = connections[i];
        if (connection > 0) {
          neighbors.push( {
            index: i,
            weight: connection
          });
        }
      }

      if (unit_test) console.log("neighbors=", neighbors);

      // Go through each neighbor, determine the tentative distance
      // If that distance is smaller than the current distance, set the distance anew.
      for (let i = 0; i < neighbors.length; i++)
      {
        let neighbor = neighbors[i];
        let neighbor_text = graph.IndexToText(neighbor.index);
        let current_node_distance = distances[current_node_index];
        let current_distance = distances[neighbor.index];
        let tentative_distance = current_node_distance + neighbor.weight;
        if (tentative_distance < current_distance)
        { // Set a new distance.
          distances[neighbor.index] = tentative_distance;
          // build a new path.
          paths[neighbor.index] = paths[current_node_index].concat([neighbor_text]);
        }
      }

      // Mark the current node as visited
      unvisited_set.splice(unvisited_set.indexOf(current_node), 1);

      // Find the next current node.
      let to_consider = [];

      for (let i = 0; i < unvisited_set.length; i++)
      {
        let unvisited_node = unvisited_set[i];
        let distance = distances[graph.TextToIndex(unvisited_node)];
        to_consider.push({
          unvisited_node,
          distance
        });
      }

      let winner = _.min(to_consider, (consider) => {
        return consider.distance;
      });

      // Finally set the current_node
      current_node = winner.unvisited_node;

    }

    return paths;
  },

}
