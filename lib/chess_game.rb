require_relative 'pieces.rb'
require_relative 'player.rb'
require_relative 'chess_board.rb'
require_relative 'regulations.rb'

class ChessGame
  include Regulations
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

  HOME_RANK = [Rook, Knight, Bishop, Queen,
               King, Bishop, Knight, Rook]

  def initialize(white_name, black_name)
    @white_player = Player.new(white_name)
    @black_player = Player.new(black_name)
    setup
    @current_player = @white_player
    @next_player = @black_player
  end

  def move(square, to)
    unless legal?(square, to)
      return puts 'Invalid Move: Illegal move.'
    end
    limbo = @board[square].content
    @board[square].content = EMPTY
    if check_prevent(@current_player.king_position)
      @board[square].content = limbo
      return puts 'Invalid Move: Your King will be in check'
    end
    limbo.site = to
    capture(@board[to].content)
    @board[to].content = limbo
  end 

  def capture(piece)
    @next_player.pieces.delete(piece)
  end

  def add(piece, color, square)
    mark = piece.to_s.downcase.to_sym
    if color == WHITE
      @board[square].content = piece.new(color[mark], square)
      @white_player.pieces << @board[square].content
    elsif color == BLACK
      @board[square].content = piece.new(color[mark], square)
      @black_player.pieces << @board[square].content
    end
  end

  def setup
    @board = ChessBoard.new.board
    0.upto(7) { |x| add(HOME_RANK[x], WHITE, [0, x]) }
    0.upto(7) { |x| add(Pawn, WHITE, [1, x])}
    0.upto(7) { |x| add(Pawn, BLACK, [6, x])}
    0.upto(7) { |x| add(HOME_RANK[x], BLACK, [7, x]) }
  end

  def show
    puts
    7.downto(0) do |rank|
      print '|'
      0.upto(7) do |file|
        square = @board[[rank, file]]
        if square.content.respond_to?(:mark)
          print square.content.mark + '|'
        else
          print square.content  + '|'
        end
      end
      puts
    end
  end

  def my_status
    @current_player.piece_status
  end

  def switch_player
    @current_player, @next_player = @next_player, @current_player
  end
end