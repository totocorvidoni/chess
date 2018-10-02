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

  context 'when it moves outside the boord' do
    it 'is not valid' do
      expect(king.valid_move?([4, -1])).to be false
    end
  end
end

