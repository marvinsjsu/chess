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

# load 'board.rb'
# game = Board.build_starting_board
# game.board
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
# game.valid_moves(:black)