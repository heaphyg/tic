class TicTacToe
  def initialize
  # User class
    @user_name = nil
    @user_piece = nil 
  # CPU class
    @cpu_piece = nil

# Board class
    @board_spaces = { 
      1 => " ",2 => " ",3 => " ",
      4 => " ",5 => " ",6 => " ",
      7 => " ",8 => " ",9 => " "
    }
# Board class
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
  end

# Tic Tac Toe class method
  def start_game
     prompt
     user_turn_choice
     initiate_first_player_move
     print_board
  end

# view 
  def prompt
    puts "Welcome to Tic Tac Toe!"
    puts "what is your name?"
    self.user_name = gets.chomp.capitalize
    return user_name
  end

# User class method
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
        puts "#{user_name} you have chosen to go second. Bold move. Please select the number of the space you wish to occupy."
        proper_piece_selection = true
        self.cpu_piece = 'X'
      end
    end
  end
 
 # User class method
  def initiate_first_player_move
    user_piece == 'X' ? user_turn : cpu_turn
  end

#view
  def border
    puts "*************************************************************************"
  end


#view stuff
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

# CPU class method
  def cpu_turn
    move = cpu_find_move
    board_spaces[move] = cpu_piece
    check_game(user_piece)
  end

# CPU class method
  def calculate_piece_occurance_in_victory_scenario(victory_scenario, piece)
    times = 0
    victory_scenario.each do |i|
      times += 1 if board_spaces[i] == piece
      unless board_spaces[i] == piece || board_spaces[i] == " "
        #opposite piece is in column so column cannot be used for win.
        #therefore, the strategic thing to do is choose a dif column so return 0.
        return 0
      end
    end
    times
  end

# CPU class method
  def find_empty_spaces_in_victory_scenario(victory_scenario)
    possible_moves = []
    victory_scenario.each do |i|  
      if board_spaces[i] == " "
        possible_moves << i
      end
    end
    puts possible_moves.inspect
    possible_moves.sample
  end

# CPU class method
  def calculate_move(piece_to_be_counted, num_of_occurances)
    potential_victory_scenarios.each do |victory_scenario|
      if calculate_piece_occurance_in_victory_scenario(victory_scenario, piece_to_be_counted) == num_of_occurances
        return find_empty_spaces_in_victory_scenario(victory_scenario)
      end
    end
    false
  end

# CPU class method
  def seek_victory
    puts "seek victory"
    calculate_move(cpu_piece, 2)
  end

# CPU class method
  def block_victory
    puts "block victory"
    calculate_move(user_piece, 2)
  end

# CPU class method
  def middle_defense
    puts "middle defense"
    if (board_spaces[1] != " " || board_spaces[3] != " " || board_spaces[7] != " " || board_spaces[9] != " ") && (board_spaces[5] == " ")
      return 5  
    end
    false
  end

# CPU class method
  def corner_defense
    puts "corner defense"
    if (board_spaces[5] != " ") && (board_spaces[1] == " " && board_spaces[3] == " " && board_spaces[7] == " " && board_spaces[9] == " ")
      return [1,3,7,9].sample
    end
    false
  end

# CPU class method
  def build_up_a_victory_scenario
    puts "build up"
    calculate_move(cpu_piece, 1)
  end

# CPU class method
  def select_random_location
    puts "random selection"
    key_collection = board_spaces.keys;
    i = rand(key_collection.length)
    if board_spaces[key_collection[i]] == " "
      return key_collection[i]
    else
      board_spaces.each { |space,value| return space if value == " " }
    end
  end

# CPU class method
  def cpu_find_move
    seek_victory ||  block_victory || middle_defense || corner_defense || build_up_a_victory_scenario || select_random_location
  end

# User class method
  def user_turn
    print_board
    input = gets.chomp
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

# User class method
  def wrong_move
    puts "You must choose an empty space"
    user_turn
  end

# User class method
  def incorrect_input
    puts "Please specify a move with an integer 1..9"
    user_turn
  end

# Tic Tac Toe class method
  def check_game(next_turn)
    game_over = nil
    potential_victory_scenarios.each do |scenario|
      if calculate_piece_occurance_in_victory_scenario(scenario, cpu_piece) == 3
        border
        puts "!!!!!!!!!!!!!!CPU WINS!!!!!!!!!!!!!!"
        game_over = true
      end
      if calculate_piece_occurance_in_victory_scenario(scenario, user_piece) == 3
        border
        puts "!!!!!!!!!!!!!!#{user_name} WINS!!!!!!!!!!!!!!"
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

# Tic Tac Toe class method
  def board_spaces_left
    spaces_left = 0
    board_spaces.each do |k, v|
      spaces_left += 1 if v == " "
    end
    spaces_left
  end


  private
# move these to the appropriate classes
  attr_reader :potential_victory_scenarios
  attr_accessor :user_piece, :cpu_piece, :board_spaces, :user_name 
end

if __FILE__ ==$0
  TicTacToe.new.start_game
end