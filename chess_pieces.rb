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

    @move_set = nil
    @attack_set = nil

    @board_moves = Board.new.possible_moves
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

class WhitePawn < ChessPiece
  def initialize (icon="p", node=nil, is_white=true)
    super
    @start_position = @current_position
  end

  def check_destination
    pawn_moves
  end

  private 

  def pawn_moves(temp_node=@current_node)
    temp_x = temp_node.data[0]
    temp_y = temp_node.data[-1]
    
    new_node_x = @move_to_node.data[0]
    new_node_y = @move_to_node.data[-1]

    x_is_same = new_node_x == temp_x ? true : false
    y_is_same = new_node_y == temp_y ? true : false

    #initial move - can move two spaces
    if @current_position == @start_position
      if new_node_x == temp_x -2
        temp_node = temp_node.up
        move_again = move_further(temp_node)
        if !temp_node.is_occupied
          temp_node = temp_node.up 
          pawn_move(temp_node)
        else
          "Path blocked"
        end
      end
    end
    #regular move
    if new_node_x == temp_x -1 && y_is_same
      temp_node = temp_node.up
      pawn_move(temp_node)
    elsif new_node_x > temp_x && y_is_same
      return "Pawn cannot move down"
    end
    #attack move
    if new_node_x == temp_x -1 && new_node_y == temp_y -1
      temp_node = temp_node.up_l
      pawn_attack(temp_node)
    elsif new_node_x == temp_x -1 && new_node_y == temp_y +1
      temp_node = temp_node.up_r
      pawn_attack(temp_node)
    end

    return "Move not valid" if new_node_x < temp_x-2 || (new_node_y > temp_y +1 || new_node_y < temp_y -1)
    return "Pawn is at this location" if x_is_same && y_is_same
  end

  def pawn_move(temp_node)
    if temp_node == @move_to_node
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
  end

  def pawn_attack(temp_node)
    if temp_node == @move_to_node
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

end

class Rook < ChessPiece

  def initialize(icon = "r", node=nil, is_white=true)
    super
  end

  def check_destination
    rook_moves
  end

  private

  def rook_moves(temp_node=@current_node)
    temp_x = temp_node.data[0]
    temp_y = temp_node.data[-1]
    
    new_node_x = @move_to_node.data[0]
    new_node_y = @move_to_node.data[-1]

    x_is_same = new_node_x == temp_x ? true : false
    y_is_same = new_node_y == temp_y ? true : false

    if new_node_x < temp_x && y_is_same
      temp_node = temp_node.up
    elsif new_node_x > temp_x && y_is_same
      temp_node = temp_node.down
    end

    if new_node_y < temp_y && x_is_same
      temp_node = temp_node.left
    elsif new_node_y > temp_y && x_is_same
      temp_node = temp_node.right
    end

    return "Move not valid" if !x_is_same && !y_is_same
    return "Rook is at this location" if x_is_same && y_is_same
    resolve_move(temp_node)
  end

  def resolve_move(temp_node)
    should_move_further = move_further(temp_node)
    return rook_moves(temp_node) if should_move_further == true
    return p move_further if !should_move_further.nil?
  end

end

# piece = ChessPiece.new
# piece.spaces

# pawn = Pawn.new("0", [7, 2])
# p pawn.move_set
# pawn.self