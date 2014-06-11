class Piece
  attr_accessor :cur_pos
  attr_reader :color
  
  ORTH = [[1, 0], [-1, 0], [0, -1], [0, 1]]
  DIAG = [[1, 1], [-1, 1], [1, -1], [-1,-1]]
  @@all_pieces = []
  
  def initialize(cur_pos, color, game)
    @cur_pos = cur_pos # [x, y] [0, 0]
    @color = color
    @game = game
  end
  
  def moves
    potential_pos = []
    self.class::VECTORS.each do |vector|
      y, x = @cur_pos
      self.class::MAX_STEPS.times do |idx|
        new_x = x + ((idx + 1) * vector[1])
        new_y = y + ((idx + 1) * vector[0])
        if (0..7).include?(new_x) && (0..7).include?(new_y)
          potential_pos << [new_y, new_x]
        end
      end
    end
    potential_pos
  end
  
  def to_s
    @symbol.to_s
  end
end

class SlidingPiece < Piece
  MAX_STEPS = 7
end

class SteppingPiece < Piece
  MAX_STEPS = 1
end
  
class Bishop < SlidingPiece 
  VECTORS = DIAG
  SYMBOLS = {white: "\u2657", black: "\u265d"}
  # def initialize(color, pos)
  #   @symbol = SYMBOLS[color]
  # end
end

class Rook < SlidingPiece
  attr_accessor :moved
  VECTORS = ORTH
end
  
class Queen < SlidingPiece 
  VECTORS = ORTH + DIAG
end

class King < SteppingPiece
  attr_accessor :moved
  VECTORS = ORTH + DIAG
  
  def initialize(cur_pos, color, game)
    super(cur_pos, color, game)
    @moved = false
  end
  
  
end

class Knight < SteppingPiece
  VECTORS = [[1, 2], [1, -2], [2, 1], [2, -1], [-1, -2], [-1, 2], [-2, 1], [-2, -1]]
end

class Pawn < Piece
  attr_accessor :moved
  
  def initialize(cur_pos, color, game)
    super(cur_pos, color, game)
    @moved = false
  end
  
 # @@orth = [[1, 0], [-1, 0]] # B, W
 # @@diag = [[1, 1], [-1, 1], [1, -1], [-1,-1]] # B, W, B, W
  
  def moves
    potential_pos = []
    ORTH[0..1].each do |vector|
      y, x = @cur_pos
      max_steps = @moved ? 1 : 2
      max_steps.times do |idx|
        new_x = x + ((idx + 1) * vector[1])
        new_y = y + ((idx + 1) * vector[0])
        if (0..7).include?(new_x) && (0..7).include?(new_y)
          potential_pos << [new_y, new_x]
        end
      end
    end
    potential_pos + self.kills
  end
  
  def kills
    potential_kills = []
    DIAG.each_with_index do |vector, idx|
      next if self.color == :white && idx.odd?
      next if self.color == :black && idx.even?
      y, x = @cur_pos
      new_x, new_y = x + vector[1], y + vector[0]
      
      
      if (0..7).include?(new_x) && (0..7).include?(new_y)
        opponent_piece = @game.board[new_x][new_y]
        unless opponent_piece.nil?
          if opponent_piece.color != self.color
             potential_kills << [new_y, new_x]
          end
        end
      end
      
      # opponent_piece = @game.board[new_x][new_y]
      # unless opponent_piece.nil?
      #   if (0..7).include?(new_x) && (0..7).include?(new_y) && opponent_piece.color != self.color
      #     potential_kills << [new_y, new_x]
      #   end
    end
    potential_kills
  end
end






