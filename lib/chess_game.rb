require_relative 'pieces.rb'
require_relative 'player.rb'
require_relative 'chess_board.rb'
require_relative 'regulations.rb'
require 'yaml'

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
    @turn = 1
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
    # puts 'Check Mate' if check_mate?
    if in_check?(@current_player.king_site)
      puts "\e[31m=== Your King is in check ===\e[0m"
    end    
    puts turn_info
    begin
      pick = player_input
      until legal?(pick[0], pick[1])
        puts 'Invalid move'
        pick = player_input
      end
      move(pick[0], pick[1])
      wrap_up
    rescue ArgumentError
      puts 'Please pick again'
      game_loop
    end
  end

  def player_input
    choice = []
    print "#{@current_player.name}, select the chess piece you wish to move: "
    from = gets.chomp.chars
    choice << from.map { |x| x.to_i - 1 }
    unless my_piece?(@board[choice[0]].content)
      puts 'Invalid Piece'
      raise ArgumentError.new
    end
    print "Moving #{@board[choice[0]].content.mark} at #{convert(from)} to... "
    to = gets.chomp.chars
    choice << to.map { |x| x.to_i - 1 }
  end

  def move(from, to)
    king = @current_player.king_site == from ? to : @current_player.king_site
    from_limbo = @board[from].content
    to_limbo = @board[to].content
    @board[from].content = EMPTY
    @board[to].content = from_limbo
    capture(to_limbo)
    if in_check?(king)
      @board[from].content = from_limbo
      @board[to].content = to_limbo
      @next_player.pieces << to_limbo
      puts 'Invalid Move: Your King will be in check'
      raise ArgumentError.new
    end
    @board[to].content.not_moved = false
    @board[to].content.site = to
  end

  def wrap_up
    if @to_be_en_passant.nil?
      @en_passant = nil
    else
      @en_passant = @to_be_en_passant
      @to_be_en_passant = nil
    end
    @turn += 1
    pawn_promotion
    show
    switch_player
    File.open('save.yaml', "w") { |file| file.puts YAML.dump(self) }
  end

  def pawn_promotion
    unless @promote.nil?
      puts 'Choose your pawn\'s promotion'
      color = WHITE.any? { |k, v| v == @promote.content.mark } ? WHITE : BLACK
      puts "1. #{color[:queen]} - 2. #{color[:knight]} - 3. #{color[:bishop]} - 4. #{color[:rook]}"
      pick = gets.to_i
      unless (1..4) === pick
        puts 'Pick a number between 1 or 4'
        pick = gets.to_i
      end
      case pick
      when 1
        add(Queen, color, @promote.site)
      when 2
        add(Knight, color, @promote.site)
      when 3
        add(Bishop, color, @promote.site)
      when 4
        add(Rook, color, @promote.site)
      end
      capture(@promote.content)
      @promote = nil
    end
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

  def capture(piece)
    @next_player.pieces.delete(piece)
  end

  def convert(coordinates)
    "[#{coordinates.join('-')}]"
  end

  def my_status
    @current_player.piece_status
  end

  def turn_info
    color = @current_player == white_player ? 'WHITE' : 'BLACK'
    "TURN: #{@turn} - #{color}"
  end

  def save_game
    puts 'Would your like to save the game and quit?'
    puts '1. YES'
    puts '2. NO'
    save = gets.to_i
    until (1..2) === save
      puts 'Invalid option'
      save = gets.to_i  
    end
    if save == 1
      File.open('save.yaml', "w") do |file|
        file.puts YAML.dump(self)
        exit  
      end
    end
  end
end
