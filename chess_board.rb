require 'pry'

class BoardSquare
  attr_reader :data
  attr_accessor :is_occupied, :piece, :square_display, :up, :down, :left, :right, :up_l, :up_r, :do_l, :do_r

  def initialize (square_coordinates, is_occupied=false)
    @data = square_coordinates
    @is_occupied = is_occupied
    @blank_square = "[ ]"

    @piece = nil
    @square_display = @blank_square

    #connections rows = x collumns = y
    @up = nil      #up       - directly up     -x, y
    @down = nil    #down     - directly down   +x, y
    @left = nil    #left     - directly left   x, -y
    @right = nil   #right    - directly right  x, +y
    
    @up_l = nil    #up left  - diagonal        -x, -y
    @up_r = nil    #up right - diagonal        -x, +y
    @do_l = nil    #downleft - diagonal        +x, -y
    @do_r = nil    #downright- diagonal        +x, +y
  end

  def update_node(piece)
    if @is_occupied
      @piece = piece
      @square_display = piece.icon
    else
      @piece = nil
      @square_display = @blank_square
    end
  end

end

class Board
  attr_reader :game_board, :possible_moves, :movement_hash
  
  def initialize
    @range = (1..8).to_a
    @game_board = generate_board
    @possible_moves = generate_moves
    @movement_hash = generate_move_hash
    connect_board_together
  end

  def show_board
    print_game_board
  end

  private

  def generate_board
    board_len = @range
    board = []
    board_len.each do |row|
        board_row = []
        board_len.each do |col|
            board_row << [row, col]
        end
        board << board_row
    end
    board
  end

  def generate_moves
    move_rows = @range
    move_collumns = @range
    move_set = []

    move_rows.each do |row|
      move_collumns.each  do |collumn|
        move_set << [row, collumn]
      end
    end
    move_set
  end

  def generate_move_hash
    move_hash = {}
    @possible_moves.each do |move|
      move_hash[move] = BoardSquare.new(move)
    end
    move_hash
  end

  def print_game_board
    print " "
    @range.each { |i| print " #{i} "}
    print "\n"
    @game_board.each_index do |row|
      print row+1
      @game_board[row].each do |r|
        print @movement_hash[r].square_display
      end
      print "\n"
    end
  end

  def connect_board_together
    @movement_hash.each_value do |node|
      @movement_hash.each_value do |other_node|
        fit_to_other_node(node, other_node)
      end
    end
  end

  def fit_to_other_node(node, other_node)
    node_x = node.data[0]
    node_y = node.data[-1]

    node2_x = other_node.data[0]
    node2_y = other_node.data[-1]

    node.up = other_node if node_x -1 == node2_x && node_y == node2_y      #up -x, y
    node.down = other_node if node_x +1 == node2_x && node_y == node2_y    #down +x, y
    node.left = other_node if node_x == node2_x && node_y -1 == node2_y    #left x, -y
    node.right = other_node if node_x == node2_x && node_y +1 == node2_y   #right x, +y
    
    node.up_l = other_node if node_x -1 == node2_x && node_y -1 == node2_y    #up left    -x, -y
    node.up_r = other_node if node_x -1 == node2_x && node_y +1 == node2_y    #up right   -x, +y
    node.do_l = other_node if node_x +1 == node2_x && node_y -1 == node2_y    #downleft   +x, -y
    node.do_r = other_node if node_x +1 == node2_x && node_y +1 == node2_y    #downright  +x, +y
  end


end

# test_board = Board.new
# test_board.show_board