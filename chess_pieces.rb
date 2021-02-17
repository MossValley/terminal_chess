require 'pry'
require './chess_board.rb'

class ChessPiece
  attr_reader :icon, :is_white, :current_node, :move_set, :attack_set
  
  def initialize(icon = "x", node=nil, is_white=true)
    @icon = icon
    @current_node = node
    @is_white = is_white
    @move_to_node = @current_node

    @current_position = @current_node.nil? ? nil : @current_node.data
    @current_x = @current_position[0].nil? ? nil : @current_position[0]
    @current_y = @current_position[-1].nil? ? nil : @current_position[-1]
  end
  
  def self_description
    "#{@icon}\n#{@current_position}"
  end

  def taken
    piece_is_taken
  end

  def move_this_piece(new_node)
    @move_to_node = new_node
    check_destination
  end

  private

  def update_position
    if @move_to_node.nil?
      @current_node.update_node(nil)
    else
      @current_node = @move_to_node
      @current_node.update_node(self)
    end

    @current_position = @current_node.nil? ? nil : @current_node.data
    @current_x = @current_position[0].nil? ? nil : @current_position[0]
    @current_y = @current_position[-1].nil? ? nil : @current_position[-1]
    nil
  end

  def piece_is_taken
    @move_to_node = nil
    update_position
  end

  def move_further(temp_node)
    if temp_node == @move_to_node
      destination_reached
    elsif temp_node.is_occupied 
      "Move blocked"
    else
      true
    end
  end

  def destination_reached
    if !@move_to_node.is_occupied #i.e. node is not occupied
      update_position
    else
      if (self.is_white ? !@move_to_node.piece.is_white : @move_to_node.piece.is_white)
        attack_enemy
      else
        "Friendly unit in position"
      end
    end
  end

  def attack_enemy
    @move_to_node.piece.taken
    update_position
  end

end

class Pawn < ChessPiece
  
  def initialize (icon="p", node=nil, is_white=true)
    super
    @start_position = @current_position
  end

  def check_destination
    pawn_moves
  end

  private 

  def pawn_moves    
    double_move = (self.is_white ? @current_x -2 : @current_x +2)
    single_move = (self.is_white ? @current_x -1 : @current_x +1)

    move_x = @move_to_node.data[0]
    move_y = @move_to_node.data[-1]

    x_is_same = move_x == @current_x ? true : false
    y_is_same = move_y == @current_y ? true : false

    #initial move - can move two spaces
    if @current_position == @start_position
      if move_x == double_move && y_is_same
        temp_node = (self.is_white ? @current_node.up : @current_node.down)
        if !temp_node.is_occupied
          pawn_move
        else
          "Path blocked"
        end
      end
    end
    #regular move
    if move_x == single_move && y_is_same
      pawn_move
    elsif (self.is_white ? move_x > @current_x : move_x < @current_x) && y_is_same
      return "Pawn cannot move down"
    end
    #attack move
    if move_x == single_move && (move_y == @current_y -1 || move_y == @current_y +1)
      pawn_attack
    end

    return "Move not valid" if (self.is_white ? move_x < @current_x -2 : move_x > @current_x +2) ||
      (move_y > @current_y +1 || move_y < @current_y -1)
    return "Pawn is at this location" if x_is_same && y_is_same
  end

  def pawn_move
    if !@move_to_node.is_occupied
      update_position
    else
      if (self.is_white ? !@move_to_node.piece.is_white : @move_to_node.piece.is_white)
        "Enemy unit in position"
      else
        "Friendly unit in position"
      end
    end
  end

  def pawn_attack
    if !@move_to_node.is_occupied
      "Cannot attack empty square"
    else
      if (self.is_white ? !@move_to_node.piece.is_white : @move_to_node.piece.is_white)
        attack_enemy
      else
        "Friendly unit in position"
      end
    end
  end
end

module RookMoves
  private

  def rook_moves(temp_node=@current_node)
    temp_x = temp_node.data[0]
    temp_y = temp_node.data[-1]
    
    move_x = @move_to_node.data[0]
    move_y = @move_to_node.data[-1]

    x_is_same = move_x == temp_x ? true : false
    y_is_same = move_y == temp_y ? true : false
    
    return "Rook is at this location" if x_is_same && y_is_same

    if move_x < temp_x && y_is_same
      temp_node = temp_node.up
    elsif move_x > temp_x && y_is_same
      temp_node = temp_node.down
    elsif move_y < temp_y && x_is_same
      temp_node = temp_node.left
    elsif move_y > temp_y && x_is_same
      temp_node = temp_node.right
    else
      return "Move not valid"
    end
    
    resolve_move(temp_node)
  end
end

module BishopMoves
  private

  def bishop_moves(temp_node=@current_node)
    temp_x = temp_node.data[0]
    temp_y = temp_node.data[-1]
    
    move_x = @move_to_node.data[0]
    move_y = @move_to_node.data[-1]

    x_is_same = move_x == temp_x ? true : false
    y_is_same = move_y == temp_y ? true : false

    return "Bishop is at this location" if x_is_same && y_is_same

    if move_x < temp_x && move_y < temp_y
      temp_node = temp_node.up_l
    elsif move_x > temp_x && move_y < temp_y
      temp_node = temp_node.do_l
    elsif move_x < temp_x && move_y > temp_y
      temp_node = temp_node.up_r
    elsif move_x > temp_x && move_y > temp_y
      temp_node = temp_node.do_r
    else
      return "Move not valid"
    end
    
    resolve_move(temp_node)
  end

end


class Rook < ChessPiece
  include RookMoves
  
  def check_destination
    rook_moves
  end

  private

  def resolve_move(temp_node)
    should_move_further = move_further(temp_node)
    return rook_moves(temp_node) if should_move_further == true
    return p move_further if !should_move_further.nil?
  end

end

class Bishop < ChessPiece
  include BishopMoves

  def check_destination
    bishop_moves
  end

  private

  def resolve_move(temp_node)
    should_move_further = move_further(temp_node)
    return bishop_moves(temp_node) if should_move_further == true
    return p move_further if !should_move_further.nil?
  end


end

# piece = ChessPiece.new
# piece.spaces

# pawn = Pawn.new("0", [7, 2])
# p pawn.move_set
# pawn.self