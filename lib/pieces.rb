class ChessPiece
  attr_accessor :site, :not_moved, :special_move
  attr_reader :mark

  def initialize(mark, site)
    @mark = mark
    @site = site
    @not_moved = true
    @special_move = false
  end

  def general_check(to)
    return false unless to.all?(0..7)
    return false if site == to
    true
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
    (site[1] - to[1]).abs == 1 ? true : false
  end

  def straight_step?(to)
    return false if site == to
    if site[0] == to[0]
      return true if (site[1] - to[1]).abs == 1
    elsif site[1] == to[1]
      return true if (site[0] - to[0]).abs == 1
    end
    false
  end
end

class King < ChessPiece
  def valid_move?(to)
    if general_check(to)
      if castling(to)
        @special_move = true
        return true
      end
      return true if diagonal_step?(to) || straight_step?(to)
    end
    false
  end

  def castling(to)
    if site[0] == to[0] && @not_moved == true
      true if (site[1] - to[1]).abs == 2 
    else
      false
    end
  end
end

class Queen < ChessPiece
  
  def valid_move?(to)
    if general_check(to)
      return true if diagonal_move?(to) || straight_move?(to)
    end
    false
  end
end

class Bishop < ChessPiece
  
  def valid_move?(to)
    if general_check(to)
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
    if general_check(to)
      travel = [(site[0] - to[0]), (site[1] - to[1])]
      return true if MOVES.any?(travel)
    end
    false
  end
end

class Rook < ChessPiece
  
  def valid_move?(to)
    if general_check(to)
      return true if straight_move?(to)
    end
    false
  end
end

class Pawn < ChessPiece

  def valid_move?(to)
    if general_check(to)
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
      @special_move = true unless to[1] == site[1] && (2..6) === to[0]
      true
    elsif to[0] == 3 && not_moved == true
      @special_move = true
      true
    else
      false
    end
  end

  def black_advance?(to)
    if site[0] - 1 == to[0] && (-1..1) === site[1] - to[1]
      @special_move = true unless to[1] == site[1] && (0..5) === to[0]
      true
    elsif to[0] == 4 && site[1] == to[1] && not_moved == true
      @special_move = true
      true
    else
      false
    end
  end
end
