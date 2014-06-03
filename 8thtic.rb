# we should change middle_defense to middle_strategy becuase both players can use it 
# the cpu is smart enough to know that if it strarts in the conerner and the user
# doesnt choose the middle - then cpu will take the middle - automaticaly causing him to win
# we should also change corner_defense to corner_strategy
# remember when you go first and hit a corner - then the opposite corner - computer builds
# up but only has options 4 and 6 -- not cool
# get all puts statements in the start_game method
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
    puts "Welcome to Tic Tac Toe!"
    puts "what is your name?"
    self.user_name = get_user_name
    self.user_piece = get_user_piece
    if user_piece == 'X'
      border
      puts "Excellent #{user_name}. You have chosen to go first. Please select the number of the space you wish to occupy."
    else
      border
      puts "#{user_name} you have chosen to go second. Bold move. Please select the number of the space you wish to occupy."
    end
    self.cpu_piece = get_cpu_piece(user_piece)
    initiate_first_player_move
    print_board
  end

# view 
  def get_user_name
    return gets.chomp.capitalize
  end

  def get_user_piece
    selection = nil
    until ['X','O'].include?(selection)
      puts "#{user_name} please write an 'X' if you would like to go first or an 'O' if you would like to go second."
      selection = gets.chomp.upcase
    end
    selection
  end

  def get_cpu_piece(user_piece)
    user_piece == 'X' ? 'O' : 'X'
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

  def scenario_spaces_analysis(scenario)  # collect that game state of a scenario
    scenario.map {|scenario_position| board_spaces[scenario_position]}
  end

  def piece_count_for_scenario(scenario, player_piece) #collects the number of pieces in scenario
    spaces = scenario_spaces_analysis(scenario)
    return 0 if spaces.any? {|space| space != player_piece && space != ' '}
    spaces.select{|space| space == player_piece}.length
  end

  def find_empty_spaces_in_victory_scenario(victory_scenario)
    victory_scenario.select {|space| board_spaces[space] == " "}.sample
  end

  def calculate_move(piece_to_be_counted, num_of_occurances)
    potential_victory_scenarios.each do |scenario|
      if piece_count_for_scenario(scenario, piece_to_be_counted) == num_of_occurances
        return find_empty_spaces_in_victory_scenario(scenario)
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
    corner_scenario = [1,3,7,9]
    middle_space = board_spaces[5] 
    corner_spaces = scenario_spaces_analysis(corner_scenario)
    if corner_spaces.any? {|space| space != ' '} && (middle_space == " ")
      return 5
    end
    false
  end

# CPU class method
  def corner_defense
    puts "corner defense"
    corner_scenario = [1,3,7,9]
    middle_space = board_spaces[5] 
    corner_spaces = scenario_spaces_analysis(corner_scenario)
    if corner_spaces.all? {|space| space == ' '} && (middle_space != " ")
      return corner_scenario.sample
    end
    false
  end

# CPU class method
  def build_up_a_victory_scenario
    puts "build up"
    calculate_move(cpu_piece, 1)
  end

# CPU class method
  def find_all_empty_spaces
    board_spaces.select { |k, v| v == " "}.keys
  end

  def select_random_location
    puts "random selection"
    find_all_empty_spaces.sample
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
      if piece_count_for_scenario(scenario, cpu_piece) == 3
        border
        puts "!!!!!!!!!!!!!!CPU WINS!!!!!!!!!!!!!!"
        game_over = true
      end
      if piece_count_for_scenario(scenario, user_piece) == 3
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