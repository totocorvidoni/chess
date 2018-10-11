require_relative 'lib/chess_game.rb'

puts 'Welcome to Chess'
puts 'Would you like to:'
puts
puts '1. Start a New Game?'
puts '2. Load Your Saved Game?'

start_game = gets.to_i
until (1..2) === start_game
  puts 'Invalid Option'
  start_game = gets.to_i
end

if start_game == 2
  chess = YAML.load File.read('save.yaml')
else
  puts '\== A New Glorious Game of Chess Begins ==/'
  puts
  puts
  print 'White player, step forward and tell us your name: '
  white_player = gets.chomp
  print 'Now, the contender! Who commands the black legion? '
  black_player = gets.chomp
  puts
  puts 'Let\'s get ready for some Chess...'
  puts
  chess = ChessGame.new(white_player, black_player)
end

chess.show

loop do
  chess.game_loop
end   