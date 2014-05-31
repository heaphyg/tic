class TicTacToe
  attr_reader :user_name
  attr_accessor :turn_choice, :opponent_piece, :board_spaces
  def initialize
    @turn_choice = nil
    @opponent_piece = nil
    @board_spaces = {     # defining all 9 board spaces and setting them as unoccupied with empty strings
      1 => "1",2 => "2",3 => "3",
      4 => "4",5 => "5",6 => "6",
      7 => "7",8 => "8",9 => "9"
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
     user_turn_choice
     assign_opponent_piece
     turn # this may not be nessecary
     print_board
  end

  def prompt
    puts "Welcome to Tic Tac Toe!"
    puts "what is your name?"
    @user_name = gets.chomp.capitalize #is it bad that I use an instance var here
  end

  def user_turn_choice
    proper_piece_selection = false
    until proper_piece_selection
      if !['X', 'O'].include?(turn_choice)
        puts "please write an 'X' if you would like to go first or an 'O' if you would like to go second"
        self.turn_choice = gets.chomp.upcase
      elsif turn_choice  == 'X'
        puts "Excellent #{user_name}. You have chosen to go first. Please select the number of the space you wish to occupy."
        proper_piece_selection = true
        player1 = user_name
        player2 = "Computer"
        # turn_choice  # im concerned that this could be DRYer
      else
        puts "#{user_name} you have chosen to go second. Bold move."
        proper_piece_selection = true
        player1 = "Computer"
        player2 = user_name
        # turn_choice # we may not even need these here
      end
    end
  end

  def assign_opponent_piece
    if turn_choice == 'X'
      self.opponent_piece = 'O'
    else
      self.opponent_piece = 'X'
    end
  end

  def turn
    if turn_choice == 'X'
      # user_turn
    else
      # opponent_turn
    end
  end

  def print_board  ## perhaps the board should have numbers printed in it..
    puts "                    #{board_spaces[1]}|#{board_spaces[2]}|#{board_spaces[3]}"
    puts "                    -----"
    puts "                    #{board_spaces[4]}|#{board_spaces[5]}|#{board_spaces[6]}"
    puts "                    -----"
    puts "                    #{board_spaces[7]}|#{board_spaces[8]}|#{board_spaces[9]}"
  end

  def opponent_turn
    move = opponenet_determine_move  # this method will eventually choose the best move to make if there is a best move
    board_spaces[move] = opponent_piece
    check_game()
  end
end

TicTacToe.new