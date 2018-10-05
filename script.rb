require_relative 'lib/chess_game.rb'

chess = ChessGame.new('toti', 'pupe')
chess.show
loop do
  chess.game_loop
end   