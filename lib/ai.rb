require_relative 'player'
require_relative 'board'
require_relative 'user'



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
    "seek victory"
    calculate_move(self.piece, 2)
  end

  def block_victory
    "block victory"
    calculate_move(user.piece, 2)
  end

  #########################
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

  ########################

  # def middle_tactic
  #   puts "middle tactic"
  #   corner_scenario = [1,3,7,9]
  #   middle_space = board.board_spaces[5] 
  #   corner_spaces = scenario_spaces_analysis(corner_scenario)
  #   if corner_spaces.any? {|space| space != ' '} && (middle_space == " ")
  #     return 5
  #   end
  #   false
  # end

  # def corner_tactic
  #   puts "corner_tactic"
  #   corner_scenario = [1,3,7,9]
  #   middle_space = board.board_spaces[5] 
  #   corner_spaces = scenario_spaces_analysis(corner_scenario)
  #   if corner_spaces.all? {|space| space == ' '} && (middle_space != " ")
  #     return corner_scenario.sample
  #   end
  #   false
  # end

  def build_up_a_victory_scenario
    puts "build up"
    calculate_move(self.piece, 1)
  end

  def find_all_empty_spaces
    board.board_spaces.select { |k, v| v == " "}.keys
  end

  def corner_scenario
    return [1,3,7,9]
  end

  def empty_corners(corners)
    corners.select {|space| board.board_spaces[space] == " "}
  end

  def start_in_corner
    puts "corner start"
    empty_corners(corner_scenario).sample
  end

  def select_random_location
    puts "select random"
    find_all_empty_spaces.sample
  end

  # def diagonal_one_scenario
  # end

  # def diagonal_two_scenario
  # end

  def diagnal_defense
    puts "diagonal DEF"
    # if scenario_spaces_analysis(diagonal_one_scenario).all? { |space| space != ' '} && empty_corners.length == 2
    #   return empty_corners.sample
    # elsif scenario_spaces_analysis(diagonal_two_scenario).all? { |space| space != ' '} && empty_corners.length == 2
    #   return empty_corners.sample
    # end
    if empty_corners(corner_scenario).length == 2
      return empty_corners(corner_scenario).sample
    end
  end

  def find_move
    seek_victory ||  block_victory || middle_tactic || corner_tactic || diagnal_defense || build_up_a_victory_scenario || start_in_corner || select_random_location
  end
end
