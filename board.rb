class Board
  attr_accessor :board
  
  def initialize
    @board = Array.new(8) { Array.new(8) { nil } }
  end
  
  def self.build_starting_board
    game = Board.new
    starting_row = [Rook, Knight, Bishop, Queen, King, Bishop, Knight, Rook]
    starting_row.each_with_index do |piece_type, idx|
      game.set_piece(piece_type, [0, idx], :white)
      game.set_piece(Pawn, [1, idx], :white)
      game.set_piece(Pawn, [6, idx], :black)
      game.set_piece(piece_type, [7, idx], :black)
    end
    game
  end
  
  # def []=(x, y, piece)
  #   @board[x][y] = piece
  #   @board[x][y]
  # end
  # 
  # def [](x, y)
  #   @board[x][y]
  # end

  def deep_dup
    copy_game = Board.build_starting_board
    copy_board = Array.new(8) { Array.new(8) { nil } }
    (0...self.board.length).each do |idx1|
      (0...self.board[idx1].length).each do |idx2|
        piece = self.board[idx1][idx2]
        unless piece.nil?
          copy_board[idx1][idx2] = piece.class.new(piece.cur_pos, piece.color, copy_game)
        end
      end
    end
    copy_game.board = copy_board
    
    copy_game
  end

  def all_pieces_of(color)
    @board.flatten.compact.select { |piece| piece.color == color }
  end
  
  def get_king(color)
    all_pieces_of(color).find {|piece| piece.is_a?(King)}
  end

  # Before board.move really makes a move, make a deep dup of the real board.
  # Simulate the move as if it's okay.
  # Then, check if the player's King's spot is in any one of the opposite color's potential moves arrays.
  # If so (true), then raise "You'll be in check if you do that!" and don't allow player to make that move.
  # If not, then do the actual move, not just the simulation.
  
  def in_check?(color) # this will be called on the deep dup board.
    # white_king = all_pieces_of(:white).select { |piece| piece.is_a?(King) }[0]
    # black_king = all_pieces_of(:black).select { |piece| piece.is_a?(King) }[0]
    opposite = color == :black ? :white : :black
    self.all_pieces_of(opposite).any? do |piece|
      piece.moves.any? { |move| move == get_king(color).cur_pos }
    end
  end
  
  def set_piece(type, pos, color)
    piece = type.new(pos, color, self)
    x, y = piece.cur_pos
    @board[x][y] = piece 
  end
  
  def move_possible?(cur_pos, new_pos)
    game_copy = self.deep_dup
    game_copy.move!(cur_pos, new_pos)
    new_x, new_y = new_pos
    
    condition1 = !game_copy.in_check?(game_copy.board[new_x][new_y].color) 
    condition2 = check_desired_pos?(cur_pos, new_pos)
    
    condition1 && condition2
    # this returns true or false ... if true, then 
    #in our game class don't allow, if false, then call move!
    
    #in main game
    #in real game ... if game.move(pos, pos)
    #if false game.move!
  end
  
  def check_desired_pos?(cur_pos, new_pos)
    cur_x, cur_y = cur_pos
    new_x, new_y = new_pos
    piece = @board[cur_x][cur_y]

    unless piece.nil?
      possible_moves = piece.moves 
      possible_moves.each do |possible_move|
        x, y = possible_move
        if !@board[x][y].nil? && @board[x][y].color == piece.color
          possible_moves.delete(possible_move)
        end  
      end
    end

    @board[new_x][new_y].nil? && possible_moves.include?([new_x, new_y])
  end
  
  def move!(cur_pos, new_pos)
    cur_x, cur_y = cur_pos
    new_x, new_y = new_pos
    piece = @board[cur_x][cur_y]
    
    if check_desired_pos?(cur_pos, new_pos)
      @board[new_x][new_y] = piece 
      @board[cur_x][cur_y] = nil
      piece.cur_pos = [new_x, new_y]
      piece.moved = true if [Pawn, King, Rook].include?(piece.class)
    else
      puts "not valid!"
    end
  end
  
  def valid_moves(color)
    valid = []
    all_pieces_of(color).each do |piece|
      cur_pos = piece.cur_pos
      valid_components = piece.moves.select do |move|
        self.move_possible?(cur_pos, move)
      end
      valid += valid_components
    end
    valid
  end
end