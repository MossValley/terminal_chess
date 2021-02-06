require 'pry'
require './chess_board.rb'

class ChessPiece
  def initialize(icon = "x", start=[7, 1])
    @icon = icon
    @current_position = start
    @current_x = @current_position[0].nil? ? nil : @current_position[0]
    @current_y = @current_position[-1].nil? ? nil : @current_position[-1]

    @board_space = Board.new.possible_moves
  end
  
  def self
    p "#{@icon}\n#{@current_position}"
  end

  def spaces
    p @board_space
  end

  def taken
    #code
  end

  private

  def piece_is_taken
    @current_position = nil
    
  end

end

class Pawn < ChessPiece
  attr_reader :move_set, :attack_set
  
  def initialize (icon = "p", start=[7, 1])
    super
    @start_possition = @current_position
    @move_set = pawn_moves
    @attack_set = pawn_attack_moves
  end

  private 

  def pawn_moves  
    moves = []

    if @current_position == @start_possition
      move = [(@current_x -2), @current_y]
      moves << move
    end

    move = [(@current_x -1), @current_y]
    moves << move

    moves
  end

  def pawn_attack_moves
    up_left = [(@current_x -1), (@current_y -1)] 
    up_right = [(@current_x -1), (@current_y +1)]
    
    moves = [up_left, up_right]
  end
end

# piece = ChessPiece.new
# piece.spaces

# pawn = Pawn.new("0", [7, 2])
# p pawn.move_set
# pawn.self