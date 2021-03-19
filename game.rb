require 'pry'
require './chess_board.rb'
require './chess_pieces.rb'

class ChessGame
  def initialize
    @board = Board.new
    @back_row_positions = {
      1 => 'rook', 2 => 'knight', 3 => 'bishop',
      4 => 'Queen', 5 => 'King',
      6 => 'bishop', 7 => 'knight', 8 => 'rook'
    }
    occupy_board
  end

  def display_board
    @board.show_board
  end

  private

  def occupy_board
    set_pawns('w', true, 2) #white
    set_pawns('b', false, 7) #black
    set_color('w', true, 8)   #white
    set_color('b', false, 1)  #black
  end

  def set_pawns(name, is_white, row)
    value = 'pawn'
    range = (1..8).to_a
    range.each do |collumn|
      piece_place(value, "[#{name+value[0]}]", is_white, [row, collumn])
    end
  end

  def set_color(name, is_white, row)
    @back_row_positions.each_pair do |k, v|
      piece_place(v, "[#{name+v[0]}]", is_white, [row, k])
    end
  end

  def piece_place(piece, icon, is_white, coordinates)
    square = @board.movement_hash[coordinates]
    piece_hash = {
      'pawn' => Pawn.new(icon, square, is_white),
      'King' => King.new(icon, square, is_white),
      'Queen' => Queen.new(icon, square, is_white), 
      'bishop' => Bishop.new(icon, square, is_white),
      'knight' => Knight.new(icon, square, is_white),
      'rook' => Rook.new(icon, square, is_white)
    }
    square.update_node(piece_hash[piece])
  end
end

test = ChessGame.new
test.display_board