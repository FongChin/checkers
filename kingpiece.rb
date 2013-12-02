# -*- coding: UTF-8 -*-

require "./piece"

class KingPiece < Piece

  def symbol
    (@color == :white)? "♔" : "♚"
  end

  def move_diffs(end_pos)
    x, y = end_pos
    up_deltas = DELTAS["up"]
    down_deltas = DELTAS["down"]
    [[x - up_deltas[0][0], y - up_deltas[0][1]], 
      [x - up_deltas[1][0], y - up_deltas[1][1]],  
      [x - down_deltas[0][0], y - down_deltas[0][1]], 
      [x - down_deltas[1][0], y - down_deltas[1][1]] ]  
  end
end

