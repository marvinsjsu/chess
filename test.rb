require_relative 'board'
require_relative 'piece'


if $PROGRAM_NAME == __FILE__
  game = Board.build_starting_board

  puts "Should be Pawn: #{game.board[1][0].class}"
  puts "Should be King: #{game.board[0][4].class}"
  current_position = [0, 1]
  new_position = [2, 2]
  game.move!(current_position, new_position)
  puts "Should be Knight: #{game.board[2][2].class}"

  puts game.all_pieces
end

load 'board.rb'
game = Board.build_starting_board
game.board

game = Board.new
game.set_piece(Rook, [4,4], :white)
game.board
game.board[4][4].moves

game.set_piece(Pawn, [4, 3], :black)
game.set_piece(King, [7,7], :white)

game.valid_moves(:white)


# 
# # game.move!([1,0],[3,0])
# # game.board
# # puts "Should be Pawn: #{game.board[3][0].class}"
# # 
# # puts "Should be Pawn: #{game.board[1][0].class}"
# # game.board[3][0].moved
# # game.board[2][0].moved
# # game.board[1][1].moved
# 
game.valid_moves(:black)


game.move!([6,5], [5,5])
game.move!([1,4], [3,4])
game.move!([6,6], [4,6])
game.move!([0,3], [4,7])