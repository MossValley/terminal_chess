require 'pry'
require './chess_board.rb'

class ChessPiece
  attr_reader :icon, :is_white, :current_node, :current_position
  
  def initialize(icon = "x", node=nil, is_white=true)
    @icon = icon
    @current_node = node
    @is_white = is_white
    @move_to_node = @current_node
    @current_position = @current_node.data
    @can_put_king_in_check = false
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

  def can_check_king(value)
    @can_put_king_in_check = value
  end
  private

  def update_position
    if @move_to_node.nil?
      @current_node.update_node(nil)
    else
      @current_node = @move_to_node
      @current_node.update_node(self)
    end

    @current_position = @current_node.data
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
      "Position occupied"
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
    if @can_put_king_in_check
      return "King can be checked"
    else
      @move_to_node.piece.taken
      update_position
    end
  end

end

class Pawn < ChessPiece
  
  def initialize (icon="p", node=nil, is_white=true)
    super
    @start_position = @current_position
  end

  def check_destination
    piece_moves
  end

  private 

  def piece_moves    
    temp_node = @current_node
    temp_x = temp_node.data[0]
    temp_y = temp_node.data[-1]

    move_x = @move_to_node.data[0]
    move_y = @move_to_node.data[-1]

    double_move = (self.is_white ? temp_x -2 : temp_x +2)
    single_move = (self.is_white ? temp_x -1 : temp_x +1)

    x_is_same = move_x == temp_x ? true : false
    y_is_same = move_y == temp_y ? true : false

    return "Pawn is at this location" if x_is_same && y_is_same

    #initial move - can move two spaces
    if @current_position == @start_position
      if move_x == double_move && y_is_same
        temp_node = (self.is_white ? temp_node.up : temp_node.down)
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
    elsif (self.is_white ? move_x > temp_x : move_x < temp_x) && y_is_same
      return "Pawn cannot move down"
    end
    #attack move
    if move_x == single_move && (move_y == temp_y -1 || move_y == temp_y +1)
      pawn_attack
    end

    return "Move not valid" if temp_node == @current_node
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

module RBQKMoves #Rook, Bishop, Queen, & King Moves
  def check_destination
    piece_moves
  end
  
  private

  def piece_moves(temp_node=@current_node)
    temp_x = temp_node.data[0]
    temp_y = temp_node.data[-1]
    
    move_x = @move_to_node.data[0]
    move_y = @move_to_node.data[-1]

    x_is_same = move_x == temp_x ? true : false
    y_is_same = move_y == temp_y ? true : false
    
    return "#{self.class.name} is at this location" if x_is_same && y_is_same

    if self.class.name == "King"
      return "King cannot move more than one square" if (move_x > temp_x +1 || move_x < temp_x -1) || 
        (move_y > temp_y +1 || move_y < temp_y -1)
    end

    unless self.class.name == "Bishop" #Rook moves - horizontal or vertical
      if move_x < temp_x && y_is_same
      temp_node = temp_node.up
      elsif move_x > temp_x && y_is_same
        temp_node = temp_node.down
      elsif move_y < temp_y && x_is_same
        temp_node = temp_node.left
      elsif move_y > temp_y && x_is_same
        temp_node = temp_node.right
      end
    end

    unless self.class.name == "Rook"  #Bishop moves - diagonally
      if move_x < temp_x && move_y < temp_y
        temp_node = temp_node.up_l
      elsif move_x > temp_x && move_y < temp_y
        temp_node = temp_node.do_l
      elsif move_x < temp_x && move_y > temp_y
        temp_node = temp_node.up_r
      elsif move_x > temp_x && move_y > temp_y
        temp_node = temp_node.do_r
      end
    end
    
    return "Move not valid" if temp_node == @current_node
    
    resolve_move(temp_node)
  end

  def resolve_move(temp_node)
    should_move_further = move_further(temp_node)
    return piece_moves(temp_node) if should_move_further == true
    return move_further if !should_move_further.nil?
  end

end

class Rook < ChessPiece
  include RBQKMoves
end

class Bishop < ChessPiece
  include RBQKMoves
end

class Queen < ChessPiece
  include RBQKMoves
end

class Knight < ChessPiece
  def check_destination
    knight_moves
  end

  def knight_moves #knight has L-shape movement either horizontal or vertical direction is the long part of L
    temp_node = @current_node

    temp_x = temp_node.data[0]
    temp_y = temp_node.data[-1]
    
    move_x = @move_to_node.data[0]
    move_y = @move_to_node.data[-1]

    x_is_same = move_x == temp_x ? true : false
    y_is_same = move_y == temp_y ? true : false
    
    return "#{self.class.name} is at this location" if x_is_same && y_is_same

    #temp_x is the long part of L
    temp_node = temp_node.up_l.up if move_x == temp_x -2 && move_y == temp_y -1 #upleftup
    temp_node = temp_node.up_r.up if move_x == temp_x -2 && move_y == temp_y +1 #uprightup
    temp_node = temp_node.do_l.down if move_x == temp_x +2 && move_y == temp_y -1 #downleftdown
    temp_node = temp_node.do_r.down if move_x == temp_x -2 && move_y == temp_y -1 #downrightdown

    #temp_y is the long part of L

    temp_node = temp_node.up_l.left if move_x == temp_x -1 && move_y == temp_y -2 #upleftleft
    temp_node = temp_node.do_l.left if move_x == temp_x +1 && move_y == temp_y -2 #downleftleft
    temp_node = temp_node.up_r.right if move_x == temp_x -1 && move_y == temp_y +2 #uprightright
    temp_node = temp_node.do_r.right if move_x == temp_x +1 && move_y == temp_y +2 #downrightright
  
    return "Move not valid" if temp_node == @current_node
    
    resolve_move(temp_node)
  end

  def resolve_move(temp_node)
    if temp_node == @move_to_node
      destination_reached
    else
      "Error"
    end
  end
end

class King < ChessPiece
  include RBQKMoves

  def initialize(icon = "k", node=nil, is_white=true)
    super
    # @rook_l = nil
    # @rook_r = nil
    @start_position = @current_position
    # @rook_l_start_pos = @rook_l.current_position
    # @rook_r_start_pos = @rook_r.current_position
    @check_array = nil
    @in_check = false
  end

  def check_for_check
    @check_array = look_around
    if @in_check
      @check_array.each { |i| "#{i}" }
    end
  end

  private 

  def look_around
    look_array = ["up", "down", "left", "right", "up_l", "up_r", "do_l", "do_r"]
    check_array = []

    look_array.each do |direction|
      look_node = @current_node.send direction
      piece_can_check = look_far(look_node, direction)
      check_array << piece_can_check if !piece_can_check.nil?
    end
    return check_array
  end
  
  def look_far(look_node, direction)
    range = (1..8).to_a

    while !look_node.nil? && (range.include?(look_node.data[0]) || range.include?(look_node.data[-1]))
      if look_node.is_occupied
        if (self.is_white ? !look_node.piece.is_white : look_node.piece.is_white)
          can_piece_attack(look_node.piece)
          return look_node.piece
        else
          return
        end
      else
        look_node = look_node.send direction
      end
    end
  end
  
  def can_piece_attack(piece)
    piece.can_check_king(true)
    response = piece.move_this_piece(self.current_node)
    if response = "King can be checked"
      @in_check = true
    end
    piece.can_check_king(false)
  end
end

# piece = ChessPiece.new
# piece.spaces

# pawn = Pawn.new("0", [7, 2])
# p pawn.move_set
# pawn.self