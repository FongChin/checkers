# -*- coding: UTF-8 -*-

class Piece
  class InvalidMoveError < StandardError
  end

  attr_accessor :position, :color
  
  def initialize(position, color, board)
    @position = position
    @color = color
    @board = board

    @board[position] = self
  end

  DELTAS = { "up" => [[-1,-1], [-1,1]], "down" => [[1, -1], [1,1]] }
  
    def valid_move_seq?(move_sequence)
    duped_board = @board.dup
    begin
      duped_board[@position].perform_moves!(move_sequence)
    rescue InvalidMoveError => e
      puts e.message
      return false
    else
      return true
    end
    
  end

  def perform_moves!(move_sequence)
    if move_sequence.length == 1
      is_valid = perform_slide(move_sequence[0]) || perform_jump(move_sequence[0])
      raise InvalidMoveError.new "Invalid Move" unless is_valid
    else
      move_sequence.each do |move_pos|
        unless perform_jump(move_pos)
          raise InvalidMoveError.new "Invalid move error while jumping"       
        end
      end
    end

  end


  def perform_moves(move_sequence)
    raise InvalidMoveError.new "Invalid Move!" unless valid_move_seq?(move_sequence)
    perform_moves!(move_sequence)
  end


  def perform_slide(end_pos)
    return false unless @board[end_pos].nil? 
    if move_diffs(end_pos).include?(@position)
      change_piece_on_board(end_pos)
      maybe_promote(end_pos) 
      return true 
    end

    false  
  end

  def perform_jump(end_pos)
    return false unless @board[end_pos].nil?
    possible_start_pos_arr = move_diffs(end_pos) 
    possible_start_pos_arr.delete_if do |pos|
      @board[pos].nil? || @board[pos].color == @color
    end
    
    possible_start_pos_arr.each do |pos|
      if move_diffs(pos).include?(@position)
        @board[pos] = nil
        change_piece_on_board(end_pos)
        maybe_promote(end_pos)
        return true
      end
    end

    false
  end
 
  def symbol
    (@color == :white)? "☆" : "★"
  end 

  def move_diffs(end_pos)
    x, y = end_pos
    up_deltas = DELTAS["up"]
    down_deltas = DELTAS["down"]
    if @color == :white
      [[x - up_deltas[0][0], y - up_deltas[0][1]], 
        [x - up_deltas[1][0], y - up_deltas[1][1]] ]  
    elsif @color == :black
      [[x - down_deltas[0][0], y - down_deltas[0][1]], 
        [x - down_deltas[1][0], y - down_deltas[1][1]] ]  
    end
  end

  def maybe_promote(pos)
    return if self.is_a? KingPiece
    if ((@color == :white && pos[0] == 0) || 
      (@color == :black && pos[0] == 7) ) 
      @board[@position] = KingPiece.new(@position, @color, @board)
    end
  end

  def change_piece_on_board(end_pos)
    @board[@position] = nil
    @board[end_pos] = self
    @position = end_pos
  end

end

require "./kingpiece"


