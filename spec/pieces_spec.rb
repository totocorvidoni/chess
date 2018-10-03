require 'pieces'

describe King do
  subject(:king) { King.new('♚', 'Pupe', [0, 4]) }

  context 'when it moves one step forward' do
    it 'is valid' do
      expect(king.valid_move?([1, 4])).to be true
    end
  end

  context 'when it moves one diagonal step' do
    it 'is valid' do
      expect(king.valid_move?([1, 3])).to be true
    end
  end

  context 'when it moves 2 steps to the side for castling' do
    it 'is valid' do
      expect(king.valid_move?([0, 2])).to be true
      expect(king.valid_move?([0, 6])).to be true      
    end    
  end

  context 'when it moves 2 steps forward' do
    it 'is not valid' do
      expect(king.valid_move?([2, 4])).to be false
    end
  end

  context 'when it moves 2 steps diagonally' do
    it 'is not valid' do
      expect(king.valid_move?([2, 2])).to be false
    end
  end

  context 'when it moves outside the board' do
    it 'is not valid' do
      expect(king.valid_move?([-1, 4])).to be false
    end
  end
end

describe Queen do
  subject(:queen) { Queen.new('♕', 'Pupe', [0, 3]) }

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

describe Bishop do
  subject(:bishop) { Bishop.new('♗', 'Pupe', [3, 2]) }

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

describe Knight do
  subject(:knight) { Knight.new('♘', 'Pupe', [2, 6]) }

  context 'when it moves 2 step fowards and 1 left' do
    it 'is valid' do
      expect(knight.valid_move?([4, 5])).to be true
    end
  end

  context 'when it moves 1 step foward and 2 steps left' do
    it 'is valid' do
      expect(knight.valid_move?([3, 4])).to be true
    end
  end

  context 'when it moves 2 steps back and one step left' do
    it 'is valid' do
      expect(knight.valid_move?([0, 5])).to be true
    end    
  end

  context 'when it moves out of board' do
    it 'is not valid' do
      expect(knight.valid_move?([3, 8])).to be false
    end
  end

  context 'when it moves horizontally' do
    it 'is not valid' do
      expect(knight.valid_move?([4, 6])).to be false
    end
  end

  context 'when it moves diagonally' do
    it 'is not valid' do
      expect(knight.valid_move?([4, 4])).to be false
    end
  end  
end

describe Rook do
  subject(:rook) { Rook.new('♜', 'Pupe', [7, 0]) }

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

describe Pawn do
  context 'when is white ♟' do
    subject(:pawn) { Pawn.new('♟', 'Pupe', [1, 0]) }

    context 'moving one step up' do
      it 'is valid' do
        expect(pawn.valid_move?([2, 0])).to be true
      end
    end
    
    context 'doing a double step' do
      it 'is valid' do
        expect(pawn.valid_move?([3, 0])).to be true
      end
    end

    context 'moving diagonally up-right' do
      it 'is valid' do
        expect(pawn.valid_move?([2, 1])).to be true
      end      
    end

    context 'moving out of board' do
      it 'is not valid' do
        expect(pawn.valid_move?([1, -1])).to be false
      end      
    end

    context 'moving backwards' do
      it 'is not valid' do
        expect(pawn.valid_move?([0, 0])).to be false
      end      
    end

    context 'moving horizontally' do
      it 'is not valid' do
        expect(pawn.valid_move?([1, 1])).to be false
      end      
    end
  end

  context 'when is black ♙' do
    subject(:pawn) { Pawn.new('♙', 'Pupe', [6, 7]) }

    context 'moving one step down' do
      it 'is valid' do
        expect(pawn.valid_move?([5, 7])).to be true
      end
    end
    
    context 'doing a double step' do
      it 'is valid' do
        expect(pawn.valid_move?([4, 7])).to be true
      end
    end

    context 'moving diagonally down-left' do
      it 'is valid' do
        expect(pawn.valid_move?([5, 6])).to be true
      end      
    end

    context 'moving out of board' do
      it 'is not valid' do
        expect(pawn.valid_move?([5, 8])).to be false
      end      
    end

    context 'moving backwards' do
      it 'is not valid' do
        expect(pawn.valid_move?([7, 7])).to be false
      end      
    end

    context 'moving horizontally' do
      it 'is not valid' do
        expect(pawn.valid_move?([6, 6])).to be false
      end      
    end
  end
end