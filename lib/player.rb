class Player
  attr_accessor :pieces
  attr_reader :name, :color

  def initialize(name, color)
    @name = name
    @color = color
    @pieces = []
  end
end