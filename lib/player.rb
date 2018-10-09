class Player
  attr_accessor :pieces
  attr_reader :name

  def initialize(name)
    @name = name.capitalize
    @pieces = []
  end

  def piece_status
    puts
    puts "Your chess pieces \nand their location on the board:"
    pieces.each do |piece|
      puts "\e[33m#{piece.mark}\e[0m in rank \e[32m#{piece.site[0]}\e[0m, file \e[32m#{piece.site[1]}\e[0m => \e[32m#{piece.site}\e[0m"
    end
    puts
  end

  def king_position
    king = pieces.select { |piece| piece.instance_of?(King) }
    king[0].site
  end
end