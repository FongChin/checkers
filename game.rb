require "./board"

class Game
  attr_accessor :player1, :player2
  def initialize(player1, player2)
    @board = Board.new
    @player1 = player1
    @player2 = player2
    @player1.color, @player2.color = :white, :black
    @player1.board = @player2.board = @board
    @current_player = @player1
  end

  def run
    @board.show
    until @board.over?
      play_turn
      @board.show
    end
    puts "game end"
    winner = ( @current_player == @player1 )? @player2 : @player1
    puts "#{winner.name} won!"
  end
  
  private
  def play_turn
    start_pos = @current_player.get_start_pos
    move_seq = @current_player.get_move_sequence(start_pos)

    @board[start_pos].perform_moves(move_seq) 

    @current_player = ( @current_player == @player1 )? @player2 : @player1
  end
  
end

class HumanPlayer
  class InvalidMoveError < StandardError
  end

  attr_accessor :color, :board, :name

  def initialize(name, color= nil, board = nil)
    @name = name
    @color = color
    @board = board
  end
  
  def get_start_pos
    begin
      puts "#{@name}, which piece do you want to move?"
      start_pos = gets.chomp.split(",").map(&:to_i)
      raise InvalidMoveError.new "position out of bound" unless @board.valid_pos?(start_pos)
      raise InvalidMoveError.new "There is no piece at that position" if @board[start_pos].nil?
      raise InvalidMoveError.new "Move your own piece!" unless @board[start_pos].color == @color
      return start_pos
    rescue InvalidMoveError => e
      puts e.message
      retry
    end
  end

  def get_move_sequence(start_pos)
    begin
      puts "#{@name}, where do you want to move your piece to? ex: 1,2|3,4"
      move_seq = gets.chomp.split("|").map do |pos|
                    pos.split(",").map(&:to_i)
                  end
      move_seq.each do |move|
        raise InvalidMoveError.new "#{move} coord is out of bound!" unless @board.valid_pos?(move)
      end 
      unless @board[start_pos].valid_move_seq?(move_seq)
        raise InvalidMoveError.new "Move Sequence not valid!"
      end

      return move_seq 
    rescue InvalidMoveError => e
      puts e.message
      retry
    end
  end
end

g = Game.new(HumanPlayer.new("F1"), HumanPlayer.new("F2"))
g.run
