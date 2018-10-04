class ChessPiece
  attr_accessor :site
  attr_reader :player, :mark

  def initialize(mark, player, site)
    @mark = mark
    @site = site
    @player = player
  end

  def in_board?(to)
    to.all?(0..7)
  end
  
  private

  def diagonal_move?(to)
    return false if site[0] == to[0] && site[1] == to[1]
    distance = site[0] - to[0]
    site[1] + distance == to[1] || site[1] - distance == to[1] ? true : false
  end

  def straight_move?(to)
    return false if site == to
    site[0] == to[0] || site[1] == to[1] ? true : false
  end

  def diagonal_step?(to)
    return false unless site[0] + 1 == to[0] || site[0] - 1 == to[0]
    site[1] + 1 == to[1] || site[1] - 1 == to[1] ? true : false
  end

  def straight_step?(to)
    return false if site == to
    if site[0] == to[0]
      return true if site[1] + 1 == to[1] || site[1] - 1 == to[1]
    elsif site[1] == to[1]
      return true if site[0] + 1 == to[0] || site[1] - 1 == to[1]
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
    if site[0] == to[0]
      true if site[1] - 2 == to[1] || site[1] + 2 == to[1]
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
      travel = [(site[0] - to[0]), (site[1] - to[1])]
      return true if MOVES.any?(travel)
    end
    false
  end

  def unobstructed?
      # should overwrite the parent method only checking for landing site
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
    if site[0] + 1 == to[0] && (-1..1) === site[1] - to[1]
      true
    elsif site[0] + 2 == to[0] && site[1] == to[1]
      true
    else
      false
    end
  end

  def black_advance?(to)
    if site[0] - 1 == to[0] && (-1..1) === site[1] - to[1]
      true
    elsif site[0] - 2 == to[0] && site[1] == to[1]
      true
    else
      false
    end  
  end  
end
