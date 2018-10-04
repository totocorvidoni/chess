class ChessBoard
  def initialize
    @board = {}
    setup_board
  end

  def setup_board
    0.upto(7) do |rank|
      0.upto(7) do |file|
        @board[[rank, file]] = Square.new('⛚', [rank, file])
      end
    end
  end  
end

class Square
  attr_reader :location, :adjecent
  attr_accessor :content

  def initialize(content, location)
    @content = content
    @location = location
    @adjacent = { up_left: [location[0].next, location[1].pred],
                  up: [location[0].next, location[1]],
                  up_right: [location[0].next, location[1].next],
                  right: [location[0], location[1].next],
                  down_right: [location[0].pred, location[1].next],
                  down: [location[0].pred, location[1]],
                  down_left: [location[0].pred, location[1].pred],
                  left: [location[0], location[1].pred] }
    clean_up
  end

  def clean_up
    @adjacent.each do |key, value|
      unless value.all?(0..7)
        @adjacent[key] = 'OFF BOARD'
      end
    end
  end
end