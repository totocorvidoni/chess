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

describe Queen do
  subject(:queen) { Queen.new('♕', [0, 3]) }

  context 'when it moves forward' do
    it 'is valid' do
      expect(queen.valid_move?([5, 3])).to be true
    end    
  end

  context 'when it moves left' do
    it 'is valid' do
      expect(queen.valid_move?([0, 7])).to be true
    end
  end

  context 'when it moves out of board' do
    it 'is not valid' do
      expect(queen.valid_move?([0, 8])).to be false
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

describe Bishop do
  subject(:bishop) { Bishop.new('♗', [3, 2]) }

  context 'when it moves diagonally down-left' do
    it 'is valid' do
      expect(bishop.valid_move?([1, 0])).to be true
    end
  end

  context 'when it moves diagonally down-right' do
    it 'is valid' do
      expect(bishop.valid_move?([0, 5])).to be true
    end    
  end

  context 'when it moves diagonally up-left' do
    it 'is valid' do
      expect(bishop.valid_move?([4, 1])).to be true
    end    
  end  

  context 'when it moves diagonally up-left' do
    it 'is valid' do
      expect(bishop.valid_move?([7, 6])).to be true
    end    
  end  

  context 'when it moves on a straight line' do
    it 'is valid' do
      expect(bishop.valid_move?([3, 7])).to be false
    end    
  end  

  context 'when it moves diagonally out of board' do
    it 'is valid' do
      expect(bishop.valid_move?([6,-1])).to be false
    end    
  end    
end
