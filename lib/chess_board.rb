class ChessBoard
  attr_reader :board
  def initialize
    @board = {}
    create_board
  end

  def create_board
    0.upto(7) do |rank|
      0.upto(7) do |file|
        @board[[rank, file]] = Square.new('⛚', [rank, file])
      end
    end
  end
end

class Square
  attr_reader :site, :adjacent
  attr_accessor :content

  def initialize(content, site)
    @content = content
    @site = site
    @adjacent = { up_left: [site[0].next, site[1].pred],
                  up: [site[0].next, site[1]],
                  up_right: [site[0].next, site[1].next],
                  right: [site[0], site[1].next],
                  down_right: [site[0].pred, site[1].next],
                  down: [site[0].pred, site[1]],
                  down_left: [site[0].pred, site[1].pred],
                  left: [site[0], site[1].pred] }
    clean_up
  end

  def clean_up
    @adjacent.each do |key, value|
      unless value.all?(0..7)
        @adjacent.delete(key)
      end
    end
  end
end