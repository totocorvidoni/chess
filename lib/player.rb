class Player
  attr_accessor :pieces
  attr_reader :name, :color

  def initialize(name, color)
    @name = name
    @color = color
    @pieces = []
  end

  def piece_status
    puts
    puts "Your chess pieces \nand their location on the board:"
    pieces.each do |piece|
      puts "\e[33m#{piece.mark}\e[0m in rank \e[32m#{piece.position[0]}\e[0m, file \e[32m#{piece.position[1]}\e[0m => \e[32m#{piece.position}\e[0m"
    end
    puts
  end
end