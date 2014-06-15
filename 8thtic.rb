class Player
  attr_accessor :piece, :name 
end

class AI < Player
  attr_reader :board, :user
  def initialize(board, user)
    @name = "Mr. Computer"
    @board = board
    @user = user
  end

  def scenario_spaces_analysis(scenario) 
    scenario.map {|scenario_position| board.board_spaces[scenario_position]}
  end

  def piece_count_for_scenario(scenario, player_piece)
    spaces = scenario_spaces_analysis(scenario)
    return 0 if spaces.any? {|space| space != player_piece && space != ' '}
    spaces.select{|space| space == player_piece}.length
  end

  def find_empty_spaces_in_victory_scenario(victory_scenario)
    victory_scenario.select {|space| board.board_spaces[space] == " "}.sample
  end

  def calculate_move(piece_to_be_counted, num_of_occurances)
    board.potential_victory_scenarios.each do |scenario|
      if piece_count_for_scenario(scenario, piece_to_be_counted) == num_of_occurances
        return find_empty_spaces_in_victory_scenario(scenario)
      end 
    end
    false
  end

  def seek_victory
    calculate_move(self.piece, 2)
  end

  def block_victory
    calculate_move(user.piece, 2)
  end

  def corner_scenario 
    return [1,3,7,9]
  end

  def corner_spaces 
    corner_spaces = scenario_spaces_analysis(corner_scenario)
    return corner_spaces
  end

  def middle_space 
    return board.board_spaces[5]
  end

  def middle_tactic
    if corner_spaces.any? {|space| space != ' '} && (middle_space == " ")
      return 5
    end
    false
  end

  def corner_tactic
    if corner_spaces.all? {|space| space == ' '} && (middle_space != " ")
      return corner_scenario.sample
    end
    false
  end

  def diagonal_one_scenario
    return [1,5,9]
  end

  def diagonal_two_scenario
    return [3,5,7]
  end

  def middle_side
    return [2,4,6,8]
  end

  # def opposing_corners_scenario_one
  #   return [7, 3]
  # end

  # def opposing_corners_scenario_two
  #   return [1, 9]
  # end

  def empty_middle_side
    if scenario_spaces_analysis(middle_side).all? { |space| space == ' ' }
      return middle_side.sample
    end
    # elsif scenario_spaces_analysis(opposing_corners_scenario_two).all? { |space| space == ' ' }
    #   return middle_side.sample
    # end
  end

  def diagnal_defense
    puts "diagonal DEF"
    if scenario_spaces_analysis(diagonal_one_scenario).all? { |space| space != ' '} && empty_middle_side
      return empty_middle_side
    elsif scenario_spaces_analysis(diagonal_two_scenario).all? { |space| space != ' '} && empty_middle_side
      return empty_middle_side
    end
  end

  def build_up_a_victory_scenario ### this might include a new mwthod call for corners
    calculate_move(self.piece, 1)
  end

  def find_all_empty_spaces
    board.board_spaces.select { |k, v| v == " "}.keys
  end

  def return_empty_corner
    empty_corners = []
    corner_scenario.each do |space|
      if board.board_spaces[space] == " "
         empty_corners << space
      end
    end
    return empty_corners.sample
  end

  def select_random_corner
    if return_empty_corner 
      return_empty_corner
    else
      find_all_empty_spaces.sample
    end
  end

  def find_move
    seek_victory ||  block_victory || middle_tactic || corner_tactic || diagnal_defense || build_up_a_victory_scenario || select_random_corner
  end
end

class User < Player
end


class Board
  attr_reader :potential_victory_scenarios
  attr_accessor :board_spaces 
  def initialize
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
  end
end


class TicTacToe
  attr_reader :ai
  attr_accessor :user,:board
  def initialize
    @user = User.new
    @board = Board.new
    @ai = AI.new(@board, @user)
  end

  # start_game collects input and provides output
  def start_game
    puts "Welcome to Tic Tac Toe!"
    puts "what is your name?"
    user.name = get_user_name
    user.piece = get_user_piece
    if user.piece == 'X'
      border
      puts "Excellent #{user.name}. You have chosen to go first. Please select the number of the space you wish to occupy."
    else
      border
      puts "#{user.name} you have chosen to go second. Bold move. Please select the number of the space you wish to occupy."
    end
    ai.piece = get_cpu_piece(user.piece)
    initiate_first_player_move
    print_board
  end

  def input
    return gets.chomp
  end

  def get_user_name
    return input.chomp.split(" ").map { |word| word.capitalize }.join(" ")
  end

  
  def get_user_piece
    selection = nil
    border
    until ['X','O'].include?(selection)
      puts "#{user.name} please write an 'X' if you would like to go first or an 'O' if you would like to go second."
      selection = input.upcase
    end
    selection
  end

  def get_cpu_piece(user_piece)
    user_piece == 'X' ? 'O' : 'X'
  end
 
  def initiate_first_player_move
    user.piece == 'X' ? user_turn : cpu_turn  
  end

  def border
    puts "*************************************************************************"
  end

  def print_board 
    border
    puts "                Gameplay Board        Reference Board"
    puts "                    #{board.board_spaces[1]}|#{board.board_spaces[2]}|#{board.board_spaces[3]}         *        1|2|3"
    puts "                   -------"
    puts "                    #{board.board_spaces[4]}|#{board.board_spaces[5]}|#{board.board_spaces[6]}         *        4|5|6"
    puts "                   -------"
    puts "                    #{board.board_spaces[7]}|#{board.board_spaces[8]}|#{board.board_spaces[9]}         *        7|8|9"
    border
  end

  def cpu_turn
    move = ai.find_move
    board.board_spaces[move] = ai.piece
    check_game(user.piece)
  end

  def respond_to_user_selection(selection)
    if board.board_spaces[selection] == " "
      board.board_spaces[selection] = user.piece
      check_game(ai.piece)
    else
      wrong_move
    end 
  end

  def user_turn
    print_board
    selection = input
    if (1..9).include?(selection.to_i)
      selection = selection.to_i
      respond_to_user_selection(selection)
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

  def game_over?
    board.potential_victory_scenarios.each do |scenario|
      if ai.piece_count_for_scenario(scenario, ai.piece) == 3  
        border
        puts "             !!!!!!!!!!!!!! #{ai.name} WINS !!!!!!!!!!!!!!"
        return true
      end
      if ai.piece_count_for_scenario(scenario, user.piece) == 3 
        border
        puts "                 !!!!!!!!!!!!!! #{user.name} WINS !!!!!!!!!!!!!!"
        return true
      end
    end
    return false
  end

  def continue_gameplay(next_turn)
    if(next_turn == user.piece)
      user_turn 
    else
      cpu_turn   
    end
  end

  def check_game(next_turn)
    unless game_over?
      if(board_spaces_left > 0)
        continue_gameplay(next_turn)
      else
        border
        puts "                 !!!!!!!!!!!!!! CAT'S GAME !!!!!!!!!!!!!!"
      end
    end
  end

  def board_spaces_left
    spaces_left = 0
    board.board_spaces.each do |k, v|
      spaces_left += 1 if v == " "
    end
    spaces_left
  end
end

if __FILE__ ==$0
  TicTacToe.new.start_game
end
