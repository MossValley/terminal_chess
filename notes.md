Game plan

--- chess_board ---
Create board class to display the board
- takes either chess piece as a slot (use nodes?), or an empty space  "[ ]"
- seperate arguments for each kind of piece?
OR
- chess_game assigns pieces to movement_hash? (rename to position_hash?)


how to determine space is free 
- select piece from game.start_position choice
- check coordinates of game.end_position
 if space is occupied by enemy.piece
 - reassign the piece.current_position AND remove enemy.piece from board
 if space is empty
 - reassign the piece.current_position to new coordinates
 if space is occupied by friend.piece
 - tell player move not possible and ask for new move


-- chess_pieces --
Create chess pieces class
- contains general attributes of all classes
- the icon
- piece color (white or black)
- current position (and x & y coordinates seperately from this)
- the availability of moves from the possible_moves varaible of board class


has method for when it is taken (deleted from the board)

Rook class
- moves and attacks available to rook
  straight line on x or y axis
    up down left right

Bishop class
- moves and attacks available to rook
  diagonal lines
    up_left, up_right, down_left, down_right

Queen class
- moves and attacks avialable to queen
  combination of bishop and rook 
    up down left right up_left up_right down_left down_right

for ^ classes
- they cannot jump so have to check for collisions between start and end posions
- if collision -> move cannot be made

Knight class
- moves and attacks available to knight
  L-shaped movements (8 possible)
    upup_L, upup_R, up_LL, up_RR
    ddown_L, ddown_R, down_LL, down_RR
- can jump, so only check for collision on end position

Pawn class
- available moves to pawn
  move one ahead (can move two in first turn)
- available attacks to pawn
  diagonal left or right
- en pessant move
  can only be done directly after enemy.pawn has moved in turn before
  - if situation occurs chess_game has to keep track of this
- pawn promotion to other piece
  - player can choose what piece: give options

King class
- moves and attacks available to king
  move one space in any direction (see queen)
- can collide with enemy.piece to attack
- can NOT move into position where 'check' can occur
  need to check against all enemy.piece.attack_set moves
- castling
  king and rook haven't moved
    * if player selects king option to castle is provided


-- chess_game --
Create Game class that sets up board

position all pieces in correct starting positions

for each player's turn generate possible moves for all pieces on board
- if king in 'check' -> player has to move king 
  OR
  player has to move piece in the way of check
  - be able to see what enemy.piece is causing check 
    - determine what path is to block sight OR remove enemy.piece

- if no moves possible for any piece -> stalemate
- else player can move any piece available

method for asking what move to do
- ask for start position (deteremines piece)
- next ask for end position (where piece moves)
- determine if end position space is free and if collision occurs on the way (done by chess board?)


* Collisions *

when player choses player.piece 
- all possible player.piece moves generate
- all other.player.piece.positions and enemy.piece.positions within player.piece.movement are loaded
  (possibly have a @collision or @attack variables for each move?)
  - if king is selected also load all enemy.piece.movements in case he crosses those boundaries?

* node system *
- every location on the chess_board is a node that can have multiple children (the pieces)
- when a player.piece is selected all its @move_set and @attack_set are generated and for every board.position node that is generated, all player.pieces or enemy.pieces that have nodes associated with that are brought up

~ board.position node properties
- updated after each move is made?
  - 1 x game_piece position: has a chess.piece as its child (child has color property and this node as its @current_position)
  - ? x game_piece "can move here" nodes: attached to multiple different pieces
    - each piece has board.position in list of potential move/attack zones
    - only required when king moves
  



