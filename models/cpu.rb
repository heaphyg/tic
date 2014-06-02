class CPU
  attr_accessor :cpu_piece
  def initialize
    @cpu_piece = nil
  end

  def cpu_turn
    move = cpu_find_move
    board_spaces[move] = cpu_piece
    check_game(user_piece)
  end

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

  def calculate_move(piece_to_be_counted, num_of_occurances)
    potential_victory_scenarios.each do |victory_scenario|
      if calculate_piece_occurance_in_victory_scenario(victory_scenario, piece_to_be_counted) == num_of_occurances
        return find_empty_spaces_in_victory_scenario(victory_scenario)
      end
    end
    false
  end

  def seek_victory
    puts "seek victory"
    calculate_move(cpu_piece, 2)
  end

  def block_victory
    puts "block victory"
    calculate_move(user_piece, 2)
  end

  def middle_defense
    puts "middle defense"
    if (board_spaces[1] != " " || board_spaces[3] != " " || board_spaces[7] != " " || board_spaces[9] != " ") && (board_spaces[5] == " ")
      return 5  
    end
    false
  end

  def corner_defense
    puts "corner defense"
    if (board_spaces[5] != " ") && (board_spaces[1] == " " && board_spaces[3] == " " && board_spaces[7] == " " && board_spaces[9] == " ")
      return [1,3,7,9].sample
    end
    false
  end

  def build_up_a_victory_scenario
    puts "build up"
    calculate_move(cpu_piece, 1)
  end

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

  def cpu_find_move
    seek_victory ||  block_victory || middle_defense || corner_defense || build_up_a_victory_scenario || select_random_location
  end
end