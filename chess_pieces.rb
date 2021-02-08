require 'pry'
require './chess_board.rb'

class ChessPiece
  attr_reader :is_white, :current_node
  
  def initialize(icon = "x", node=nil, is_white=true)
    @icon = icon
    @current_node = node
    @is_white = is_white
    @move_to_node = @current_node

    # @current_position = @current_node.nil? ? nil : @current_node.data
    # @current_x = @current_position[0].nil? ? nil : @current_position[0]
    # @current_y = @current_position[-1].nil? ? nil : @current_position[-1]

    update_position

    @move_set = nil
    @attack_set = nil

  end
  
  def self
    p "#{@icon}\n#{@current_position}"
  end

  def taken
    piece_is_taken
  end

  def move_this_piece(new_node)
    @move_to_node = new_node
    check_path
  end

  private

  def update_position
    @current_node = @move_to_node
    @current_position = @current_node.nil? ? nil : @current_node.data
    @current_x = @current_position[0].nil? ? nil : @current_position[0]
    @current_y = @current_position[-1].nil? ? nil : @current_position[-1]
  end

  def piece_is_taken
    @move_to_node = nil
    update_position
  end

  def check_path
    if @move_set.include?(@move_to_node)
      valid_move
    else
      "Move not valid"
    end
  end

  def valid_move
    if !@move_to_node.is_occupied #i.e. node is not occupied
      update_position
    else
      if @attack_set.include?(@move_to_node) && (self.is_white ? @move_to_node.piece.is_white : !@move_to_node.piece.is_white)
        attack_enemy
      else
      "Position occupied by friendly piece"
      end
    end
  end

  def attack_enemy
    @move_to_node.piece.piece_is_taken
    update_position
  end

end

class WhitePawn < ChessPiece
  attr_reader :move_set, :attack_set
  
  def initialize (icon="p", node=nil, is_white=true)
    super
    @start_position = @current_position
    @move_set = pawn_moves
    @attack_set = pawn_attack_moves
  end

  private 

  def pawn_moves  
    moves = []

    if @current_position == @start_position
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