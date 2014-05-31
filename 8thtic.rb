class TicTacToe
  class TicTacToe
  attr_reader :user_name
  attr_accessor :turn_choice, :opponent_piece, :board_spaces
  def initialize
    @turn_choice = nil
    @opponent_piece = nil
    @board_spaces = {     # defining all 9 board spaces and setting them as unoccupied with empty strings
      1 => " ",2 => " ",3 => " ",
      4 => " ",5 => " ",6 => " ",
      7 => " ",8 => " ",9 => " "
    }

    @potential_victory_scenarios = [
      [1,2,3], # 3 potential horizontal victories
      [4,5,6], 
      [7,8,9],
      [1,4,7], # 3 potential vertical victories
      [2,5,8],
      [3,6,9],
      [1,5,9], # 2 potential diagonal victories
      [3,5,7]
    ]
    conduct_game
  end

  def conduct_game
     prompt
  end

  def prompt
    puts "Welcome to Tic Tac Toe!"
    puts "what is your name?"
    @user_name = gets.chomp.capitalize #is it bad that I use an instance var here
  end

end