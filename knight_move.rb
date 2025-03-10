# knight_moves.rb

class KnightNode
  attr_reader :position, :predecessors

  def initialize(position, predecessors = [])
    @position = position  # [x, y] coordinates
    @predecessors = predecessors  # Array of previous positions
  end
end

def knight_moves(start_pos, end_pos)
  # Validate input
  unless valid_position?(start_pos) && valid_position?(end_pos)
    puts "Invalid position! Coordinates must be between 0 and 7."
    return nil
  end

  # If start and end are the same, return immediately
  return [[start_pos]] if start_pos == end_pos

  # Use BFS to find shortest path
  queue = [KnightNode.new(start_pos)]
  visited = { start_pos => nil }  # Hash to track visited positions and predecessors

  until queue.empty?
    current_node = queue.shift
    current_pos = current_node.position

    # Generate all possible knight moves
    possible_moves(current_pos).each do |next_pos|
      next unless valid_position?(next_pos) && !visited.key?(next_pos)

      # Create new node with path history
      new_predecessors = current_node.predecessors + [current_pos]
      new_node = KnightNode.new(next_pos, new_predecessors)

      visited[next_pos] = current_pos  # Record predecessor
      queue << new_node

      # If we reached the target, reconstruct and return the path
      if next_pos == end_pos
        path = reconstruct_path(start_pos, end_pos, visited)
        print_path(path)
        return path
      end
    end
  end

  puts "No path found!"  # This shouldn't happen on a valid chessboard
  nil
end

# Check if position is within 8x8 chessboard
def valid_position?(pos)
  pos.is_a?(Array) && pos.length == 2 &&
    pos[0].between?(0, 7) && pos[1].between?(0, 7)
end

# Generate all possible knight moves from a position
def possible_moves(pos)
  x, y = pos
  [
    [x + 2, y + 1], [x + 2, y - 1], [x - 2, y + 1], [x - 2, y - 1],
    [x + 1, y + 2], [x + 1, y - 2], [x - 1, y + 2], [x - 1, y - 2]
  ]
end

# Reconstruct the path from start to end using predecessors
def reconstruct_path(start_pos, end_pos, visited)
  path = [end_pos]
  current_pos = end_pos

  while current_pos != start_pos
    current_pos = visited[current_pos]
    path.unshift(current_pos)
  end
  path
end

# Print the path in the required format
def print_path(path)
  puts "You made it in #{path.length - 1} moves! Here's your path:"
  path.each { |pos| puts pos.inspect }
end

# Test cases
puts "Test 1: [0,0] to [1,2]"
knight_moves([0,0], [1,2])
puts "\nTest 2: [0,0] to [3,3]"
knight_moves([0,0], [3,3])
puts "\nTest 3: [3,3] to [0,0]"
knight_moves([3,3], [0,0])
puts "\nTest 4: [0,0] to [7,7]"
knight_moves([0,0], [7,7])
puts "\nTest 5: [3,3] to [4,3]"
knight_moves([3,3], [4,3])