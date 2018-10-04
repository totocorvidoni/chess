require_relative 'pieces.rb'
require_relative 'player.rb'
require_relative 'chess_board.rb'

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
    @white_player = Player.new(white_name)
    @black_player = Player.new(black_name)
    setup
    @current_player = @white_player
  end

  # def legal?(from, to)
  #   piece = @board[from[0]][from[1]]
  #   piece.valid_move(from, to)
  #   @current_player.pieces.any(piece)
  #   castling
  #   en_passant
  #   path_clear?
  #   check_prevent
  # end

  def path_clear?(from, to)
    case @board[from].content
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
    if @board[to].content == EMPTY
      true
    else
      false
    end
  end

  def rook_clear?(from, to)
    if from[0] == to[0]
      distance = from[1] - to[1]
      if distance < 0

        true
      else
        @board[from[0]][from[1.next]...distance].each do |path|
          return false unless path == EMPTY || path.instace_of?(Rook)
        end
      end
    end
  end

  def check_adjacent(from, direction, steps=0)
    return steps if from.adjacent[direction] == nil
    steps += 1
    return steps unless @board[from.adjacent[direction]].content == EMPTY 
    check_adjacent(@board[from.adjacent[direction]], direction, steps)
  end
    
  def move(from, to)
    @board[from].content = @board[to].content
    @board[from].content = EMPTY
    @board[to].content.site = to
  end

  def capture(piece)
    @white_player.pieces.delete(piece)
    @black_player.pieces.delete(piece)
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
end