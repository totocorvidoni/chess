class ChessPiece
  attr_accessor :position
  attr_reader :player, :mark

  def initialize(mark, position)
    @mark = mark
    @position = position
  end

  def in_board?(to)
    to.all?(0..7)
  end

  def move(start, stop) # -> legality should be checked on child classes
    if valid_move? 
      board.move_piece
    end
  end

  def check_prevent
    # check before moving if the king will not end up in check
    # maybe with an each loop on all the enemy pieces on the kings position
  end

  def unobstructed?
    # will return true if there are no pieces between the start and stop 
  end

  private

  def diagonal_move?(to)
    return false if position[0] == to[0] && position[1] == to[1]
    distance = position[0] - to[0]
    position[1] + distance == to[1] || position[1] - distance == to[1] ? true : false
  end

  def straight_move?(to)
    return false if position == to
    position[0] == to[0] || position[1] == to[1] ? true : false
  end

  def diagonal_step?(to)
    return false unless position[0] + 1 == to[0] || position[0] - 1 == to[0]
    position[1] + 1 == to[1] || position[1] - 1 == to[1] ? true : false
  end

  def straight_step?(to)
    return false if position == to
    if position[0] == to[0]
      return true if position[1] + 1 == to[1] || position[1] - 1 == to[1]
    elsif position[1] == to[1]
      return true if position[0] + 1 == to[0] || position[1] - 1 == to[1]
    end
    false
  end
end

class King < ChessPiece
  
  def valid_move?(to)
    if in_board?(to)
     return true if diagonal_step?(to) || straight_step?(to)
    end
    false
  end

  def unobstructed?
    # should overwrite the parent unobstructed taking in account the castling    
  end

  def castling

    # if
    #   "The king and the chosen rook are on the player's first rank.
    #   Neither the king nor the chosen rook has previously moved.
    #   There are no pieces between the king and the chosen rook.
    #   The king is not currently in check.
    #   The king does not pass through a square that is attacked by an enemy piece.
    #   The king does not end up in check. (True of any legal move.)"
    #   do the castling
    #   end
    # end  

  end
end

class Queen < ChessPiece
  
  def valid_move?(to)
    if in_board?(to)
      return true if diagonal_move?(to) || straight_move?(to)
    end
    false
  end
end

class Bishop < ChessPiece
  
  def valid_move?(to)
    if in_board?(to)
      return true if diagonal_move?(to)
    end
    false
  end
end

class Knight < ChessPiece

  MOVES = [[2, 1], [-2, 1], [2, -1],
          [-2, -1], [1, 2], [-1, 2],
          [1, -2], [-1, -2]]
  
  def valid_move?(to)
    if in_board?(to)
      travel = [(position[0] - to[0]), (position[1] - to[1])]
      return true if MOVES.any?(travel)
    end
    false
  end

  def unobstructed?
      # should overwrite the parent method only checking for landing position
  end
end

class Rook < ChessPiece
  
  def valid_move?(to)
    if in_board?(to)
      return true if straight_move?(to)
    end
    false
  end

  def unobstructed?
    # should overwrite the parent unobstructed taking in account the castling    
  end


end

class Pawn < ChessPiece
  
  def valid_move?
    step
    double step
    capture
    en passant
  end

  def en_passant
  end

end
