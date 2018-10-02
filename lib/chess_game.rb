require_relative 'pieces.rb'
require_relative 'player.rb'

class ChessGame
  def initialize
    
  end

  def move_piece 
  end

  def capture_piece
  end

  def add_piece
  end

  def setup
    @grid = Array.new(8) { Array.new }
  end

  def show
  end
  
  def new_player(name, color)
    Player.new(name, color)
  end
end