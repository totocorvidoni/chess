class ChessPiece
  attr_accessor :position
  attr_reader :player, :mark

  def initialize(mark, player, position)
    @mark = mark
    @position = position
    @player = player
  end

  def in_board?(to)
    to.all?(0..7)
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
     return true if castling(to)
    end
    false
  end

  def castling(to)
    if position[0] == to[0]
      true if position[1] - 2 == to[1] || position[1] + 2 == to[1]
    else
      false
    end
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
end

class Pawn < ChessPiece
  
  def valid_move?(to)
    if in_board?(to)
      case @mark
      when '♟'
        return true if white_advance?(to)
      when '♙'
        return true if black_advance?(to)
      end
    end
    false
  end

  def white_advance?(to)    
    if position[0] + 1 == to[0] && (-1..1) === position[1] - to[1]
      true
    elsif position[0] + 2 == to[0] && position[1] == to[1]
      true
    else
      false
    end
  end

  def black_advance?(to)
    if position[0] - 1 == to[0] && (-1..1) === position[1] - to[1]
      true
    elsif position[0] - 2 == to[0] && position[1] == to[1]
      true
    else
      false
    end  
  end  
end
