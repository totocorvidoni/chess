require_relative 'pieces.rb'
require_relative 'player.rb'

class ChessGame
  attr_reader :board

  WHITE = {king:   '♚',
           queen:  '♛',
           bishop: '♝',
           knight: '♞',
           rook:   '♜',
           pawn:   '♟'}

  BLACK = {king:   '♔',
           queen:  '♕',
           bishop: '♗',
           knight: '♘',
           rook:   '♖',
           pawn:   '♙'}

  EMPTY = '⛚'

  HOME_RANK = [Rook, Knight, Bishop, Queen,
               King, Bishop, Knight, Rook]

  def initialize(white_name, black_name)
    setup
    @white_player = Player.new(white_name, 'white')
    @black_player = Player.new(black_name, 'black')
  end

  def move(from, to)
    # if @board[from[0]][from[1]].move(to)
    # end
  end

  def capture_piece
  end

  def move(start, stop) # -> legality should be checked on child classes
    if valid_move? 
      board.move_piece
    end
  end

  def check_prevent
    # check before moving if the king will not end up in check
    # maybe with an each loop on all the enemy pieces on the kings position
  end

  def unobstructed?
    # will return true if there are no pieces between the start and stop 
  end


  def add(piece, color, position)
    mark = piece.to_s.downcase.to_sym
    @board[position[0]][position[1]] = piece.new(color[mark], position)
  end

  def setup
    @board = Array.new(8) { Array.new }
      x = 0 
    HOME_RANK.each do |piece|
      add(piece, WHITE, [0, x])
      x += 1
    end
    x = 0
    8.times do
      add(Pawn, WHITE, [1, x])
      x += 1
    end
    @board.fill(2..5) { Array.new(8) { EMPTY } }
    x = 0
    8.times do
      add(Pawn, BLACK, [6, x])
      x += 1
    end
    x = 0
    HOME_RANK.each do |piece|
      add(piece, BLACK, [7, x])
      x += 1
    end
  end

  def show
    @board.each do |rank|
      print '|'
      rank.each do |square|
        if square.respond_to?(:mark)
          print square.mark + '|'
        else
          print square  + '|'
        end
      end
      puts
    end
  end

  def new_player(name, color)
    Player.new(name, color)
  end
end