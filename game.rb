require 'pry'
require './chess_board.rb'
require './chess_pieces.rb'

class ChessGame
  def initialize
    @board = Board.new
    @white_turn = true
    @winner = false
    @back_row_positions = {
      1 => 'rook', 2 => 'knight', 3 => 'bishop',
      4 => 'Queen', 5 => 'King',
      6 => 'bishop', 7 => 'knight', 8 => 'rook'
    }
    occupy_board
    @error_message = {
      'no piece' => "There is no piece here. Try again",
      'not yours' => "This piece is not yours. Try again",
      'permission' => "Only numbers 1 to 8 are permitted. To exit type 'e' or 'exit'.",
      'closing' => "**Closing program**"
    }
  end

  def display_board
    @board.show_board
  end

  def play_turn
    while !@winner
      @output_message = {
      'selection' => (@white_turn ? "White" : "Black") << "'s turn. What piece do you want to move? " ,
      'move' => "Where do you want to move it? "
    }
      piece_selection
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

  def piece_selection
    player_piece = check_input('selection', true)
    piece_movement(player_piece)
  end

  def piece_movement(player_piece)
    destination_node = check_input('move')
    response = player_piece.move_this_piece(destination_node)
    if !response.nil? 
      resolve_errors(response) 
    else
      end_of_turn
    end
  end

  def check_input(part_of_move, piece_selection_phase=false, input_good=false)
    until input_good
      print @output_message[part_of_move]
      input = gets.chomp
      if !input.match?(/[^1-8]/)
        processed_input = process_input(input, piece_selection_phase)
        input_good = processed_input
      elsif input.match?(/e|exit/i)
        puts @error_message['closing']
        exit
      else
        puts @error_message['permission']
      end
    end
    processed_input
  end

  def process_input(input, piece_selection_phase)
    selected_node = @board.movement_hash[[input[0].to_i, input[-1].to_i]]
    if piece_selection_phase
      player_piece = selected_node.piece
      if player_piece.nil?
        puts @error_message['no piece']
      elsif player_piece.is_white != @white_turn
        puts @error_message['not yours']
      else
        return player_piece
      end
    else
      return selected_node
    end  
  end

  def end_of_turn
    display_board
    @white_turn = !@white_turn
    #check if king is in check
  end 

  def resolve_errors(error)
    display_board
    puts "#{error}. Try again"
  end

end

test = ChessGame.new
test.display_board
test.play_turn