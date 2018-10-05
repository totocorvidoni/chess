require 'chess_game'

describe ChessGame do
  subject(:chess) { ChessGame.new('Toto', 'Pupe') }
  it { is_expected.to respond_to(:setup) }
  
  describe '@board to represent the board' do
    it 'consist in an hash using coordinates as keys' do
      expect(chess.board).to be_kind_of(Hash)
      expect(chess.board.size).to eq(64)
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

  describe '#check_adjacent will return the distance to another piece in the given direction' do
    context 'from pawn to pawn' do
      it 'is 5' do
        expect(chess.check_adjacent(chess.board[[1, 1]], :up)).to eq(5)
      end
    end

    context 'from [4, 4] to white pawn' do
      it 'is 3' do
        expect(chess.check_adjacent(chess.board[[4, 4]], :down)).to eq(3)
      end      
    end

    context 'diagonally from pawn to pawn' do
      it 'is 5' do
        expect(chess.check_adjacent(chess.board[[1, 0]], :up_right)).to eq(5)
      end
    end

    context 'from [5, 0] to end of board' do
      it 'is 7' do
        expect(chess.check_adjacent(chess.board[[5, 0]], :right)).to eq(7)
      end
    end

    context 'from [0, 1] to [1, 1]' do
      it 'is 1' do
        expect(chess.check_adjacent(chess.board[[0, 1]], :up)).to eq(1)
      end
    end
  end

  describe '#straight_clear will return true if there are no obtacles between origin and destination' do
    context 'Rook at [2, 6]' do
      context 'going [6, 6]' do
        it 'is clear' do
          allow(chess).to receive(:check_adjacent).with([2, 6], :up).and_return(4)
          expect(chess.straight_clear?([2, 6], [6, 6])).to be true
        end
      end

      context 'going [2, 0]' do
        it 'is clear' do
          allow(chess).to receive(:check_adjacent).with([2, 6], :left).and_return(6)
          expect(chess.straight_clear?([2, 6], [2, 0])).to be true
        end
      end

      context 'going [6, 7]' do
        it 'is not clear' do
          allow(chess).to receive(:check_adjacent).with([2, 6], :up).and_return(4)
          expect(chess.straight_clear?([2, 6], [6, 7])).to be false
        end
      end
    end
  end

  describe '#diagonal_clear? will return true if there are no obtacles between origin and destination' do
    context 'bishop is at [3, 4]' do
      context 'it moves [6, 7]' do
        it 'is clear' do
          allow(chess).to receive(:check_adjacent).with([3, 4], :up_right).and_return(3)
          expect(chess.diagonal_clear?([3, 4], [6, 7])).to be true          
        end
      end

      context 'it moves [7, 0]' do
        it 'is not clear' do
          allow(chess).to receive(:check_adjacent).with([3, 4], :up_left).and_return(3)
          expect(chess.diagonal_clear?([3, 4], [7, 0])).to be false
        end
      end

      context 'it moves [1, 2]' do
        it 'is clear' do
          allow(chess).to receive(:check_adjacent).with([3, 4], :down_left).and_return(2)
          expect(chess.diagonal_clear?([3, 4], [1, 2])).to be true
        end
      end

      context 'it moves [1, 6]' do
        it 'is not clear' do
          allow(chess).to receive(:check_adjacent).with([3, 4], :down_right).and_return(2)
          expect(chess.diagonal_clear?([3, 4], [0, 7])).to be false
        end
      end
    end    
  end
end
