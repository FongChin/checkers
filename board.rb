require './piece'

class Board
  attr_accessor :grid
  def initialize(fill_board = true)
    prep_board(fill_board)
  end

  def [](pos)
    @grid[pos[0]][pos[1]]
  end
  
  def []=(pos, piece)
    raise "Invalid Pos" unless valid_pos?(pos)
    @grid[pos[0]][pos[1]] = piece
  end

  def dup
    duped_board = Board.new(false)
    
    pieces.each do |piece|
      piece.class.new(piece.position, piece.color, duped_board)
    end

    duped_board
  end

  def show
    puts (0..7).to_a.join(" ")
    str = @grid.map do |row|
      row.map do |piece|
        piece.nil? ? "_" : piece.symbol
      end.join("|")
    end.join("\n")

    puts str

    puts (0..7).to_a.join(" ")
  end

  def over?
    pieces.all? {|piece| piece.color == :white } ||
      pieces.all? {|piece| piece.color == :black }
  end

  def valid_pos?(pos)
    pos.all? { |coord| coord.between?(0,7) }
  end

  protected
  def pieces
    @grid.flatten.compact
  end

  def prep_board(fill_board)
    @grid = Array.new(8) {Array.new(8, nil)}  

    if fill_board
      fill_white_pieces
      fill_black_pieces
    end

  end

  def fill_white_pieces
    piece_at_start = false 

    (5..7).each do |row_index|
      piece_at_start = !piece_at_start
      8.times do |col_index|
        if piece_at_start 
          @grid[row_index][col_index] = Piece.new([row_index, col_index], :white, self)
        end
        piece_at_start = !piece_at_start
      end
    end

  end

  def fill_black_pieces
    piece_at_start = true 

    3.times do |row_index|
      piece_at_start = !piece_at_start
      8.times do |col_index|
        if piece_at_start 
          @grid[row_index][col_index] = Piece.new([row_index, col_index], :black, self)
        end
        piece_at_start = !piece_at_start
      end
    end

  end

end

