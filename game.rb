require 'pry'
require './chess_board.rb'
require './chess_pieces.rb'

class ChessGame
  def initialize
    @board = Board.new
    @white_turn = true
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

  def play_turn
    winner = false
    while !winner
      if @white_turn
        winner = piece_selection(true)
      else
        winner = piece_selection(false)
      end
    end
    binding.pry
  end

  private

  def occupy_board
    set_pawns('w', true, 7) #white
    set_pawns('b', false, 2) #black
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

  def piece_selection(is_white)
    piece_white = !is_white
    while piece_white != is_white
      print "#{is_white ? "White" : "Black"}'s turn. What piece do you want to move? "
      piece_to_move = gets.chomp
      if !piece_to_move.match?(/[^0-9]/)
        piece_coordinates = [piece_to_move[0].to_i, piece_to_move[-1].to_i]
        player_piece = @board.movement_hash[piece_coordinates].piece
        if player_piece.nil?
          puts "There is no piece here. Try again"
        elsif player_piece.is_white != is_white
          puts "This piece is not yours. Try again"
        else 
          piece_white = is_white
        end
      elsif piece_to_move.match?(/[exit]/i)
        puts "**Closing program**"
        exit
      else
        puts "Only numbers are permitted. To exit type 'e' or 'exit'."
      end
    end
    piece_movement(player_piece)
  end

  def piece_movement(player_piece)
    print "Where do you want to move it? "
    move_piece_to = gets.chomp
    move_coordinates = [move_piece_to[0].to_i, move_piece_to[-1].to_i]
    destination_node = @board.movement_hash[move_coordinates]
    response = player_piece.move_this_piece(destination_node)
    if !response.nil? 
      resolve_errors(response) 
    else
      end_of_turn
    end
  end

  def end_of_turn
    display_board
    @white_turn = !@white_turn
    #check if king is in check
    false
  end 

  def resolve_errors(error)
    puts error
    display_board
    false
  end

end

test = ChessGame.new
test.display_board
test.play_turn