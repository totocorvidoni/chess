require_relative 'pieces.rb'
require_relative 'player.rb'
require_relative 'chess_board.rb'
require_relative 'regulations.rb'
require 'pry'

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

  def setup
    @board = ChessBoard.new.board
    0.upto(7) { |x| add(HOME_RANK[x], WHITE, [0, x]) }
    0.upto(7) { |x| add(Pawn, WHITE, [1, x])}
    0.upto(7) { |x| add(Pawn, BLACK, [6, x])}
    0.upto(7) { |x| add(HOME_RANK[x], BLACK, [7, x]) }
  end

  def game_loop
    pick = player_input
    until legal?(pick[0], pick[1])
      puts 'Invalid move'
      pick = player_input
    end
    begin
      move(pick[0], pick[1])
      show
      switch_player
    rescue ArgumentError
      puts 'Please pick again'
      game_loop
    end
  end

  def player_input
    choice = []
    puts 'Select the chess piece you wish to move'
    # puts 'simply pick the corresponding letter and number'
    # puts 'for example b4'
    from = gets.chomp.chars
    choice << from.map { |x| x.to_i - 1 }
    puts "You are moving: #{convert(from)}->#{@board[choice[0]].content.mark}"
    puts 'Select where you wish to move it'
    to = gets.chomp.chars
    choice << to.map { |x| x.to_i - 1 }
  end

  def move(from, to)
    limbo = @board[from].content
    @board[from].content = EMPTY
    if in_check?(@current_player.king_position)
      @board[from].content = limbo
      puts 'Invalid Move: Your King will be in check'
      raise ArgumentError.new
    end
    limbo.site = to
    capture(@board[to].content)
    @board[to].content = limbo
    @en_pasant = nil
  end 

  def show
    rank_tag = ['①', '②', '③', '④', '⑤', '⑥', '⑦', '⑧']
    puts
    puts "\e[32m ① ② ③ ④ ⑤ ⑥ ⑦ ⑧\e[0m"
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
      print "\e[33m#{rank_tag[rank]}\e[0m"
      puts
    end
    # puts "\e[32m ⓐ ⓑ ⓒ ⓓ ⓔ ⓕ ⓖ ⓗ\e[0m"
    puts
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

  def switch_player
    @current_player, @next_player = @next_player, @current_player
  end

  def my_status
    @current_player.piece_status
  end

  def capture(piece)
    @next_player.pieces.delete(piece)
  end

  def convert(coordinates)
    "[#{coordinates.join('-')}]"
  end
end
