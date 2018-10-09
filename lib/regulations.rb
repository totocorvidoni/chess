module Regulations
  EMPTY = '⛚'

  def legal?(from, to)
    piece = @board[from].content
    return false unless piece.is_a?(ChessPiece)
    return false unless piece.valid_move?(to)
    return false unless @current_player.pieces.any?(piece)
    if piece.special_move
      return true if resolve_special_cases(piece, to)
    else
      return true if path_clear?(from, to)
    end
    false
  end

  def in_check?(king)
    @next_player.pieces.each do |piece|
      if piece.valid_move?(king)
        if piece.instance_of?(Pawn)
          return true if pawn_diagonal?(piece.site, king)
        else
          return true if path_clear?(piece.site, king)
        end
      end
    end
    false
  end

  def resolve_special_cases(piece, to)
    from = piece.site
    piece.special_move = false
    case piece
    when King
      return true if castling(from, to)
    when Pawn
      return true if pawn_diagonal?(from, to)
      return true if double_step(from, to)    
    end
    false
  end

  def castling(from, to)
    # need to check if king won't be checked in transit
    if from[1] < to[1]
      if straight_clear?(from, to)
        if @board[[from[0], 7]].content.not_moved == true
          # move rook left of king
          return true
        end
      end
    elsif from[1] > to[1]
      if straight_clear?(from, [to[0], (to[1] - 1)])
        if @board[[from[0], 0]].content.not_moved == true
          # move rook right of king
          return true
        end
      end
    end
    false
  end

  def pawn_diagonal?(from, to)
    unless from[1] == to[1]
      if enemy_piece?(@board[to].content)
        return true
      elsif [to[0 + 1], to[1]] == @en_passant || [to[0 - 1], to[1]] == @en_passant
        return true
        # capture(en_passant)
      end
    end
    false
  end

  def double_step(from, to)
    if (from[0] - to[0]).abs == 2
      if straight_clear?(from, to)
        @en_passant = @board[to]
        return true
      end
    end
    false    
  end

  def path_clear?(from, to)
    case @board[from].content
    when Rook
      straight_clear?(from, to)
    when Bishop
      diagonal_clear(from, to)
    when Queen
      queen_clear?(from, to)
    when King, Knight, Pawn
      true
    else
      false
    end
  end

  def straight_clear?(from, to)
    if from[0] == to[0]
      distance = to[1] - from[1]
      if distance < 0 
        return true if distance.abs == check_adjacent(from, :left)
      elsif distance > 0
        return true if distance.abs == check_adjacent(from, :right)
      end
    elsif from[1] == to[1]
      distance = to[0] - from[0]
      if distance < 0
        return true if distance.abs == check_adjacent(from, :down)
      elsif distance > 0
        return true if distance.abs == check_adjacent(from, :up)
      end  
    end
    false
  end

  def diagonal_clear?(from, to)
    distance = to[1] - from[1]
    if from[0] < to[0]
      if from[1] < to[1]
        return true if distance.abs == check_adjacent(from, :up_right)
      elsif from[1] > to[1]
        return true if distance.abs == check_adjacent(from, :up_left)
      end
    elsif from[0] > to[0]
      if from[1] < to[1]
        return true if distance.abs == check_adjacent(from, :down_right)
      elsif from[1] > to[1]
        return true if distance.abs == check_adjacent(from, :down_left)
      end
    end
    false
  end

  def queen_clear?(from, to)
    if from[0] == to[0] || from[1] == to[1]
      straight_clear?(from, to)      
    else
      diagonal_clear?(from, to)
    end
  end

  def check_adjacent(from, direction, steps= 0)
    from = @board[from]
    return steps if from.adjacent[direction] == nil
    steps += 1
    return steps unless @board[from.adjacent[direction]].content == EMPTY 
    check_adjacent(@board[from.adjacent[direction]], direction, steps)
  end

  def enemy_piece?(target)
    return true if @next_player.pieces.any?(target)
    false
  end

  def my_piece?(target)
    return true if @current_player.pieces.any?(target)
    false    
  end
end