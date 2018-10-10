module Regulations
  EMPTY = '⛚'

  def legal?(from, to)
    piece = @board[from].content
    return false unless piece.is_a?(ChessPiece)
    return false unless piece.valid_move?(to)
    return false unless @current_player.pieces.any?(piece)
    return false if @current_player.pieces.any?(@board[to].content)
    if piece.special_move
      return true if resolve_special_cases(piece, to)
    else
      return true if path_clear?(from, to)
    end
    false
  end

  def in_check?(king_site)
    @next_player.pieces.each do |piece|
      if piece.valid_move?(king_site)
        if piece.instance_of?(Pawn)
          switch_player # temporary switch to properly check pawn diagonal
          if pawn_diagonal?(piece.site, king_site)
            switch_player
            return true
          else
            switch_player
          end
        else
          return true if path_clear?(piece.site, king_site)
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
      return true if promotion?(to)
      return true if pawn_diagonal?(from, to)
      return true if double_step(from, to)    
    end
    false
  end

  def castling(from, to)
    if from[1] < to[1]
      if straight_clear?(from, to)
        if @board[[from[0], 7]].content.not_moved == true
          0.upto(2) do |x|
            return false if in_check?([from[0], [from[1] + x]])
          end
          move([from[0], 7], [from[0], 5])
          return true
        end
      end
    elsif from[1] > to[1]
      if straight_clear?(from, [to[0], (to[1] - 1)])
        if @board[[from[0], 0]].content.not_moved == true
          0.upto(2) do |x|
            return false if in_check?([from[0], [from[1] - x]])
          end
          move([from[0], 0], [from[0], 3])
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
      elsif [from[0], (from[1] + 1)] == @en_passant || [from[0], (from[1] - 1)] == @en_passant
        if @next_player.pieces.any?(@board[@en_passant].content)
          capture(@board[@en_passant].content)
          @board[@en_passant].content = EMPTY
        end
        return true
      end
    end
    false
  end

  def double_step(from, to)
    if (from[0] - to[0]).abs == 2
      if straight_clear?(from, to)
        @to_be_en_passant = @board[to].site
        return true
      end
    end
    false    
  end

  def promotion?(to)
    if to[0] == 0 || to[0] == 7
      @promote = @board[to]
    end
  end

  def path_clear?(from, to)
    case @board[from].content
    when Pawn
      pawn_clear?(from, to)
    when Rook
      straight_clear?(from, to)
    when Bishop
      diagonal_clear?(from, to)
    when Queen
      queen_clear?(from, to)
    when King, Knight
      true
    else
      false
    end
  end

  def straight_clear?(from, to)
    if from[0] == to[0]
      distance = to[1] - from[1]
      if distance < 0 
        return true if distance.abs == check_adjacent(from, to, :left)
      elsif distance > 0
        return true if distance.abs == check_adjacent(from, to, :right)
      end
    elsif from[1] == to[1]
      distance = to[0] - from[0]
      if distance < 0
        return true if distance.abs == check_adjacent(from, to, :down)
      elsif distance > 0
        return true if distance.abs == check_adjacent(from, to, :up)
      end  
    end
    false
  end

  def diagonal_clear?(from, to)
    distance = to[1] - from[1]
    if from[0] < to[0]
      if from[1] < to[1]
        return true if distance.abs == check_adjacent(from, to, :up_right)
      elsif from[1] > to[1]
        return true if distance.abs == check_adjacent(from, to, :up_left)
      end
    elsif from[0] > to[0]
      if from[1] < to[1]
        return true if distance.abs == check_adjacent(from, to, :down_right)
      elsif from[1] > to[1]
        return true if distance.abs == check_adjacent(from, to, :down_left)
      end
    end
    false
  end

  def pawn_clear?(from, to)
    if @board[to].content == EMPTY
      true
    else
      false
    end
  end

  def queen_clear?(from, to)
    if from[0] == to[0] || from[1] == to[1]
      straight_clear?(from, to)      
    else
      diagonal_clear?(from, to)
    end
  end

  def check_adjacent(from, to, direction, steps= 0)
    from = @board[from]
    up_next = from.adjacent[direction]
    return steps if up_next == nil || from.site == to
    steps += 1
    return steps unless @board[up_next].content == EMPTY
    check_adjacent(up_next, to, direction, steps)
  end

  def enemy_piece?(target)
    @next_player.pieces.any?(target) ? true : false
  end

  def my_piece?(target)
    @current_player.pieces.any?(target) ? true : false
  end
end