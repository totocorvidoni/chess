require 'chess_game'

describe ChessGame do
  subject(:chess) { ChessGame.new('Toto', 'Pupe') }
  it { is_expected.to respond_to(:setup) }
  
  describe '@board to represent the board' do
    it 'consist in an array of 8 nested arrays' do
      expect(chess.board).to be_kind_of(Array)
      expect(chess.board.map { |x| x.size }.all?(8)).to be true
    end
  end  

  describe '#show displays the state of @board' do
    context 'at the start of the game' do
      it 'displays the setted up board' do
        expect { chess.show }.to output(puts).to_stdout
      end
    end      
  end

  describe 'Player current pieces are stored in an array' do
    context 'when the game is created' do
      it 'adds the 16 pieces to white player' do
        expect(chess.white_player.pieces.size).to eq(16)
        expect(chess.white_player.pieces).to be_kind_of(Array)        
      end
    end
  end

  describe '#unobstructed? check if the path planned is free' do
    context 'when a pawn moves one square ahead' do
      it 'is valid' do
        expect(chess.path_clear?([1, 0], [2, 0])).to be true
      end
    end
  end
end
