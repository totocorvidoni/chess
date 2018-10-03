require 'chess_game'

describe ChessGame do
  it { is_expected.to respond_to(:setup) }

  # describe '#setup prepares the game' do
  # end

  describe '@board to represent the board' do

    it 'consist in an array of 8 nested arrays' do
      expect(subject.board).to be_kind_of(Array)
      expect(subject.board.map { |x| x.size }.all?(8)).to be true
    end
  end  

  describe '#show displays the state of @board' do
    context 'at the start of the game' do
      it 'displays the setted up board' do
        expect { subject.show }.to output(puts).to_stdout
      end
    end      
  end
end
