require 'pry'

class Board
  attr_reader :game_board, :possible_moves, :movement_hash
  
  def initialize
    @range = (1..8).to_a
    @square_node = "[ ]"
    @game_board = generate_board
    @possible_moves = generate_moves
    @movement_hash = generate_move_hash
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
      move_hash[move] = @square_node
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
        print @movement_hash[r]
      end
      print "\n"
    end
  end

end

# test_board = Board.new
# test_board.show_board