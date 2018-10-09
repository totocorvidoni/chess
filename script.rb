require_relative 'lib/chess_game.rb'

chess = ChessGame.new('Toti', 'Pupe')
chess.show
loop do
  chess.game_loop
end   