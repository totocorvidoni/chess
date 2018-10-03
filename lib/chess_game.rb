require_relative 'pieces.rb'
require_relative 'player.rb'

class ChessGame
  attr_reader :board, :white_player, :black_player

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
    @white_player = Player.new(white_name, 'white')
    @black_player = Player.new(black_name, 'black')
    setup
    @current_player = @white_player
  end

  def legal?(from, to)
    piece = @board[from[0]][from[1]]
    piece.valid_move(from, to)
    @current_player.pieces.any(piece)
    castling
    en_passant
    path_clear?
    check_prevent
  end

  def path_clear?(from, to)
    case @board[from[0]][from[1]]
    when Pawn
      pawn_clear?(to)
    when Rook
      rook_clear?(from, to)
    when Knight
      knight_clear?(from, to)
    when Bishop
      bishop_clear?(from, to)
    when Queen
      queen_clear?(from, to)
    when King
      king_clear?(from, to)
    end
  end

  def pawn_clear?(to)
    if @board[to[0]][to[1]] == EMPTY
      true
    else
      false
    end
  end

  def rook_clear?(from, to)

    
  end


  def move(from, to)
    @board[to[0]][to[1]] = @board[from[0]][from[1]]
    @board[from[0]][from[1]] = EMPTY
  end

  # def capture_piece
  # end


  def add(piece, color, position)
    mark = piece.to_s.downcase.to_sym
    if color == WHITE
      @board[position[0]][position[1]] = piece.new(color[mark], @white_player, position)
      @white_player.pieces << @board[position[0]][position[1]]
    elsif color == BLACK
      @board[position[0]][position[1]] = piece.new(color[mark], @black_player, position)
      @black_player.pieces << @board[position[0]][position[1]]
    end
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
    puts
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

  def my_status
    @current_player.piece_status
  end
end