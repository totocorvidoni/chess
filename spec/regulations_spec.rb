require 'chess_game.rb'
require 'regulations'

describe 'is the module in charge of checking the legality of moves' do
  subject(:chess) { ChessGame.new('Toto', 'Pupe') }
  it { is_expected.to respond_to(:setup) }

  # describe '#check_adjacent will return the distance to another piece in the given direction' do
  #   context 'from pawn to pawn' do
  #     it 'is 5' do
  #       expect(chess.check_adjacent(chess.board[[1, 1]], chess.board[[6, 1]], :up)).to eq(5)
  #     end
  #   end

  #   context 'from [4, 4] to white pawn' do
  #     it 'is 3' do
  #       expect(chess.check_adjacent(chess.board[[4, 4]], chess.board[[1, 4]], :down)).to eq(3)
  #     end      
  #   end

  #   context 'diagonally from pawn to pawn' do
  #     it 'is 5' do
  #       expect(chess.check_adjacent(chess.board[[1, 0]], chess.board[[6, 5]], :up_right)).to eq(5)
  #     end
  #   end

  #   context 'from [5, 0] to end of board' do
  #     it 'is 7' do
  #       expect(chess.check_adjacent(chess.board[[5, 0]], chess.board[[5, 7]], :right)).to eq(7)
  #     end
  #   end

  #   context 'from [0, 1] to [1, 1]' do
  #     it 'is 1' do
  #       expect(chess.check_adjacent(chess.board[[0, 1]], chess.board[[1, 1]],:up)).to eq(1)
  #     end
  #   end
  # end

  describe '#straight_clear will return true if there are no obtacles between origin and destination' do
    context 'Rook at [2, 6]' do
      context 'going [6, 6]' do
        it 'is clear' do
          allow(chess).to receive(:check_adjacent).with([2, 6], [6, 6], :up).and_return(4)
          expect(chess.straight_clear?([2, 6], [6, 6])).to be true
        end
      end

      context 'going [2, 0]' do
        it 'is clear' do
          allow(chess).to receive(:check_adjacent).with([2, 6], [2, 0], :left).and_return(6)
          expect(chess.straight_clear?([2, 6], [2, 0])).to be true
        end
      end

      context 'going [6, 7]' do
        it 'is not clear' do
          allow(chess).to receive(:check_adjacent).with([2, 6], [6, 7], :up).and_return(4)
          expect(chess.straight_clear?([2, 6], [6, 7])).to be false
        end
      end
    end
  end

  describe '#diagonal_clear? will return true if there are no obtacles between origin and destination' do
    context 'bishop is at [3, 4]' do
      context 'it moves [6, 7]' do
        it 'is clear' do
          allow(chess).to receive(:check_adjacent).with([3, 4], [6, 7], :up_right).and_return(3)
          expect(chess.diagonal_clear?([3, 4], [6, 7])).to be true          
        end
      end

      context 'it moves [7, 0]' do
        it 'is not clear' do
          allow(chess).to receive(:check_adjacent).with([3, 4], [7, 0], :up_left).and_return(3)
          expect(chess.diagonal_clear?([3, 4], [7, 0])).to be false
        end
      end

      context 'it moves [1, 2]' do
        it 'is clear' do
          allow(chess).to receive(:check_adjacent).with([3, 4], [1, 2], :down_left).and_return(2)
          expect(chess.diagonal_clear?([3, 4], [1, 2])).to be true
        end
      end

      context 'it moves [1, 6]' do
        it 'is not clear' do
          allow(chess).to receive(:check_adjacent).with([3, 4], [1, 6], :down_right).and_return(1)
          expect(chess.diagonal_clear?([3, 4], [1, 6])).to be false
        end
      end
    end
  end

  describe '#queen_clear? will return true if there are no obtacles between origin and destination' do
    context 'queen is at [5, 3]' do
      context 'it moves [1, 3]' do
        it 'is clear' do
          allow(chess).to receive(:check_adjacent).with([5, 3], [1, 3], :down).and_return(4)
          expect(chess.queen_clear?([5, 3], [1, 3])).to be true
        end
      end

      context 'it moves [3, 3]' do
        it 'is clear' do
          allow(chess).to receive(:check_adjacent).with([5, 3], [3, 3], :down).and_return(2)
          expect(chess.queen_clear?([5, 3], [3, 3])).to be true
        end
      end

      context 'it moves [1, 7]' do
        it 'is clear' do
          allow(chess).to receive(:check_adjacent).with([5, 3], [1, 7], :down_right).and_return(4)
          expect(chess.queen_clear?([5, 3], [1, 7])).to be true
        end
      end

      context 'it moves [5, 0]' do
        it 'is clear' do
          allow(chess).to receive(:check_adjacent).with([5, 3], [5, 0], :left).and_return(3)
          expect(chess.queen_clear?([5, 3], [5, 0])).to be true
        end
      end

      context 'it moves [7, 5]' do
        it 'is clear' do
          allow(chess).to receive(:check_adjacent).with([5, 3], [7, 5], :up_right).and_return(4)
          expect(chess.queen_clear?([5, 3], [7, 5])).to be false
        end
      end

      context 'it moves [4, 4]' do
        it 'is clear' do
          allow(chess).to receive(:check_adjacent).with([5, 3], [4, 4], :down_right).and_return(1)
          expect(chess.queen_clear?([5, 3], [4, 4])).to be true
        end
      end
    end
  end

  describe '#resolve_special_cases will check if a special move is legal' do
    describe '#pawn_diagonal will only let move the pawn diagonally if there is an enemy piece to capture' do
      context 'pawn moves diagonally with no piece to capture' do
        it 'is illegal' do
          expect(chess.pawn_diagonal?([1, 1], [2, 2])).to be false
        end
      end

      context 'pawn moves diagonally with an enemy piece to capture' do
        it 'is legal' do
          allow(chess).to receive(:enemy_piece?).with('⛚').and_return(true)
          expect(chess.pawn_diagonal?([1, 1], [2, 2])).to be true
        end
      end
    end
  end

  describe '#pawn_diagonal? it returns true only when the pawn is capturing' do
    context 'when capturing en passant' do
      before do
        chess.move([1, 0], [3, 0])
        chess.move([3, 0], [4, 0])
        chess.switch_player
        chess.legal?([6, 1],[4, 1])
        chess.move([6, 1], [4, 1])
        chess.switch_player
        chess.legal?([4, 0],[5, 1])
        chess.move([4, 0], [5, 1])
      end

      it 'is valid' do
        expect(chess.board[[4, 1]].content).to eq('⛚')
      end
    end    
  end
end
