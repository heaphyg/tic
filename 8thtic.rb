# rename turn_choice user ??

class TicTacToe
  attr_reader :user_name
  attr_accessor :user, :cpu, :opponent_piece, :board_spaces 
  def initialize
    @opponent_piece = nil
    @user = nil
    @cpu = nil

    @board_spaces = { 
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
     assign_cpu_piece
     initiate_first_player_move # this may not be nessecary
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
      if !['X', 'O'].include?(user)
        puts "please write an 'X' if you would like to go first or an 'O' if you would like to go second"
        self.user = gets.chomp.upcase  
      elsif user  == 'X'
        puts "Excellent #{user_name}. You have chosen to go first. Please select the number of the space you wish to occupy."
        proper_piece_selection = true
        self.cpu = 'O'
      else
        puts "#{user_name} you have chosen to go second. Bold move."
        proper_piece_selection = true
        self.cpu = 'X'
      end
    end
  end

  def assign_cpu_piece
    if user == 'X'
      self.cpu = 'O'
    else
      self.cpu = 'X'
    end
  end

  def initiate_first_player_move
    if user == 'X'
      # user_turn
    else
      # cpu_turn
    end
  end

  def print_board  ## perhaps the board should have numbers printed in it..
    puts "                    #{board_spaces[1]}|#{board_spaces[2]}|#{board_spaces[3]}"
    puts "                    -----"
    puts "                    #{board_spaces[4]}|#{board_spaces[5]}|#{board_spaces[6]}"
    puts "                    -----"
    puts "                    #{board_spaces[7]}|#{board_spaces[8]}|#{board_spaces[9]}"
  end


  def cpu_turn
    move = cpu_find_move
    self.board_spaces[move] = cpu
    # put_line
    check_game(user)
  end


  def caluclute_piece_occurance_in_victory_scenario(victory_scenario, piece)
  times = 0
    victory_scenario.each do |i|
      times += 1 if board_spaces[i] == piece
      unless board_spaces[i] == piece || board_spaces[i] == " "
        #oppisite piece is in column so column cannot be used for win.
        #therefore, the strategic thing to do is choose a dif column so return 0.
        return 0
      end
    end
    times
  end

  def find_empty_spaces_in_victory_scenario(victory_scenario)
    victory_scenario.each do |i|
      if board_spaces[i] == " "
        return i
      end
    end
  end

  def cpu_find_move
    potential_victory_scenarios.each do |victory_scenario|
      if caluclute_piece_occurance_in_victory_scenario(victory_scenario, cpu) == 2
        return find_empty_spaces_in_victory_scenario(victory_scenario)
      end
    end
  end
end

TicTacToe.new