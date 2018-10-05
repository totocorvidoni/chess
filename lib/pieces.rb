class ChessPiece
  attr_accessor :site, :not_moved
  attr_reader :mark

  def initialize(mark, site)
    @mark = mark
    @site = site
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
  attr_accessor :special_move
  
  def valid_move?(to)
    if in_board?(to)
      if castling(to) && @not_moved == true
        @special_move = true
        return true
      end
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
  attr_accessor :special_move
  
  def valid_move?(to)
    if in_board?(to)
      case @mark
      when '♟'
        if white_double_step?(to)
          @special_move = true
          @double_step = true
          return true
        end
        return true if white_advance?(to)
      when '♙'
        if black_double_step?(to)
          @special_move = true
          return true
        end
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

  def white_double_step?(to)
    return true if site[0] + 2 == to[0] && not_moved == true
    false
  end

  def black_double_step?(to)
    return true if site[0] - 2 == to[0] && not_moved == true
    false
  end
end
