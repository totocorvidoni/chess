class Piece
  attr_accessor :position
  attr_reader :player, :mark

  WHITE = {king:   '♚',
           queen:  '♛',
           bishop: '♝',
           knight: '♞',
           rook:   '♜',
           pawn:   '♟'}

  BLACK = {king:   '♔',
           queen:  '♕',
           bishop: '♗',
           knight: '♘',
           rook:   '♖',
           pawn:   '♙'}

  # OFF_BOUNDS -> maybe? to globally determine the range of the board
  # def off_bounds?
  #   move.each {all}

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

  def diagonal_move?(from, to)
    return false if from[0] == to[0] || from[1] == to[1]
    distance = (from[0] - to[0])
    from[1] + distance == to[1] || from[1] - distance == to[1] ? true : false
  end

  def straight_move?(from, to)
    return false if from == to
    from[0] == to[0] || from[1] == to[1] ? true : false
  end

  def diagonal_step?(from, to)
    return false unless from[0] + 1 == to[0] || from[0] - 1 == to[0]
    from[1] + 1 == to[1] || from[1] - 1 == to[1] ? true : false
  end

  def straight_step?(from, to)
    return false if from == to
    if from[0] == to[0]
      return true if from[1] + 1 == to[1] || from[1] - 1 == to[1]
    elsif from[1] == to[1]
      return true if from[0] + 1 == to[0] || from[1] - 1 == to[1]
    end
    false
  end


class King < Piece
  def initialize(color, position)
    @mark = color[:king]
    @position = position
  end

  def valid_move?

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

class Rook < Piece
  def initialize(color, position)
    @mark = color[:rook]
    @position = position
  end

  def valid_move?

  end

  def unobstructed?
    # should overwrite the parent unobstructed taking in account the castling    
  end


  end

  class Bishop < Piece
    def initialize(color, position)
      @mark = color[:bishop]
      @position = position
    end

    def valid_move?
    end  

  end

  class Queen < Piece
    def initialize(color, position)
      @mark = color[:queen]
      @position = position
    end

    def valid_move?
    end

  end

  class Knight < Piece
    def initialize(color, position)
      @mark = color[:knight]
      @position = position
    end

    def valid_move?
    end

    def unobstructed?
      # should overwrite the parent method only checking for landing position
    end

  end

  class Pawn < Piece
    def initialize(color, position)
      @mark = color[:pawn]
      @position = position
    end

    def valid_move?
      step
      double step
      capture
      en passant
    end

    def en_passant
    end

  end