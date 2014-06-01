# change cpu to cpu_piece and user to user_piece
# break down stuff in check_game and cpu_find_move into methods??
# make sure the user can't type a non integer as a value..
# do the sleeper ... stuf for computer's move
class TicTacToe
  attr_reader :potential_victory_scenarios
  attr_accessor :user_piece, :cpu_piece, :opponent_piece, :board_spaces, :user_name 
  def initialize
    @user_name = nil
    @opponent_piece = nil
    @user_piece = nil
    @cpu_piece = nil

    @board_spaces = { 
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
     user_turn_choice
     assign_cpu_piece
     initiate_first_player_move # this may not be nessecary
     print_board
  end

  def prompt
    puts "Welcome to Tic Tac Toe!"
    puts "what is your name?"
    self.user_name = gets.chomp.capitalize #is it bad that I use an instance var here
  end

  def user_turn_choice
    proper_piece_selection = false
    until proper_piece_selection
      if !['X', 'O'].include?(user_piece)
        puts "#{user_name} please write an 'X' if you would like to go first or an 'O' if you would like to go second."
        self.user_piece = gets.chomp.upcase  
      elsif user_piece  == 'X'
        border
        puts "Excellent #{user_name}. You have chosen to go first. Please select the number of the space you wish to occupy."
        proper_piece_selection = true
        self.cpu_piece = 'O'
      else
        border
        puts "#{user_name} you have chosen to go second. Bold move."
        proper_piece_selection = true
        self.cpu_piece = 'X'
      end
    end
  end

  def assign_cpu_piece
    if user_piece == 'X'
      self.cpu_piece = 'O'
    else
      self.cpu_piece = 'X'
    end
  end

  def initiate_first_player_move
    if user_piece == 'X'
      user_turn
    else
      cpu_turn
    end
  end

  def border
    puts "*************************************************************************"
  end

  def print_board 
    border
    puts "                Gameplay Board        Reference Board"
    puts "                    #{board_spaces[1]}|#{board_spaces[2]}|#{board_spaces[3]}         *        1|2|3"
    puts "                   -------"
    puts "                    #{board_spaces[4]}|#{board_spaces[5]}|#{board_spaces[6]}         *        4|5|6"
    puts "                   -------"
    puts "                    #{board_spaces[7]}|#{board_spaces[8]}|#{board_spaces[9]}         *        7|8|9"
    border
  end


  def cpu_turn
    move = cpu_find_move
    self.board_spaces[move] = cpu_piece
    check_game(user_piece)
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
    # calculate potential winning move
    potential_victory_scenarios.each do |victory_scenario|
      if caluclute_piece_occurance_in_victory_scenario(victory_scenario, cpu_piece) == 2
        return find_empty_spaces_in_victory_scenario(victory_scenario)
      end
    end
    # calculate potential defensive block
    potential_victory_scenarios.each do |victory_scenario|
      if caluclute_piece_occurance_in_victory_scenario(victory_scenario, user_piece) == 2
        return find_empty_spaces_in_victory_scenario(victory_scenario)
      end
    end
    # if player one starts in corner - move to middle
    if (board_spaces[1] != " " || board_spaces[3] != " " || board_spaces[7] != " " || board_spaces[9] != " ") && (board_spaces[5] == " ")
        return 5  
    end
    # build up a victory scenario
    potential_victory_scenarios.each do |victory_scenario|
      if caluclute_piece_occurance_in_victory_scenario(victory_scenario, cpu_piece) == 1
        return find_empty_spaces_in_victory_scenario(victory_scenario)
      end
    end
    # random selection
    key_collection = board_spaces.keys;
    i = rand(key_collection.length)
    if board_spaces[key_collection[i]] == " "
      return key_collection[i]
    else
      board_spaces.each { |space,value| return space if value == " " }
    end
  end

  def user_turn
    print_board
    input = gets.chomp
    # if input.to_i.class == Fixnum
    if (1..9).include?(input.to_i)
      input = input.to_i
      if board_spaces[input] == " "
        board_spaces[input] = user_piece
        check_game(cpu_piece)
      else
        wrong_move
      end
    else
      incorrect_input
    end
  end

  def wrong_move
    puts "You must choose an empty space"
    user_turn
  end

  def incorrect_input
    puts "Please specify a move with an integer 1..9"
    user_turn
  end

  def check_game(next_turn)
    game_over = nil
    potential_victory_scenarios.each do |scenario|
      if caluclute_piece_occurance_in_victory_scenario(scenario, cpu_piece) == 3
        border
        puts "!!!!!!!!!!!!!!CPU WINS!!!!!!!!!!!!!!"
        game_over = true
      end
      if caluclute_piece_occurance_in_victory_scenario(scenario, user_piece) == 3
        border
        puts "!!!!!!!!!!!!!!#{@user_name} WINS!!!!!!!!!!!!!!"
        game_over = true
      end
    end
    unless game_over
      if(board_spaces_left > 0)
        if(next_turn == user_piece)
          user_turn
        else
          cpu_turn
        end
      else
        border
        puts "!!!!!!!!!!!!!!DRAW!!!!!!!!!!!!!!"
      end
    end
  end

  def board_spaces_left
    spaces_left = 0
    board_spaces.each do |k, v|
      spaces_left += 1 if v == " "
    end
  spaces_left
  end
end

TicTacToe.new