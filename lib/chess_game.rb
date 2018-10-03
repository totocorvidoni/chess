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

  def initialize
    setup
  end

  def move(piece, to)
    # if @board[from[0]][from[1]].move(to)
    # end
  end

  def capture_piece
  end

  def add(piece, color, position)
    mark = piece.to_s.downcase.to_sym
    piece.new(color[mark], position)
  end

  def setup
    @board = []
    @board[0] = [BLACK[:rook], BLACK[:knight], BLACK[:bishop], BLACK[:queen], BLACK[:king], BLACK[:bishop], BLACK[:knight], BLACK[:rook]]
    @board[1] = Array.new(8) { BLACK[:pawn] }
    @board.fill(2..5) { Array.new(8) { EMPTY } }
    @board[6] = Array.new(8) { WHITE[:pawn] }
    @board[7] = [WHITE[:rook], WHITE[:knight], WHITE[:bishop], WHITE[:queen], WHITE[:king], WHITE[:bishop], WHITE[:knight], WHITE[:rook]]
  end

  def show
    @board.each do |rank|
      puts "|#{rank.join('|')}|"
    end
  end

  def new_player(name, color)
    Player.new(name, color)
  end
end