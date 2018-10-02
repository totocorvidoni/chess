require 'pieces'

describe King do
  subject(:king) { King.new('♚', [4, 0]) }

  context 'when it moves one step forward' do
    it 'is valid' do
      expect(king.valid_move?([4, 1])).to be true
    end
  end

  context 'when it moves one diagonal step' do
    it 'is valid' do
      expect(king.valid_move?([3, 1])).to be true
    end
  end

  context 'when it moves 2 steps forward' do
    it 'is not valid' do
      expect(king.valid_move?([4, 2])).to be false
    end
  end

  context 'when it moves 2 steps diagonally' do
    it 'is not valid' do
      expect(king.valid_move?([2, 2])).to be false
    end
  end

  context 'when it moves outside the board' do
    it 'is not valid' do
      expect(king.valid_move?([4, -1])).to be false
    end
  end
end

describe Rook do
  subject(:rook) { Rook.new('♜', [7, 0]) }

  context 'when it moves forward' do
    it 'is valid' do
      expect(rook.valid_move?([7, 7])).to be true
    end    
  end  

  context 'when it moves left' do
    it 'is valid' do
      expect(rook.valid_move?([0, 0])).to be true
    end
  end

  context 'when it moves diagonally' do
    it 'is not valid' do
      expect(rook.valid_move?([5, 2])).to be false
    end
  end

  context 'when it moves out of the board' do
    it 'is not valid' do
      expect(rook.valid_move?([8, 7])).to be false      
    end    
  end
end
