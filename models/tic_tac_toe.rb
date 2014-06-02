class TicTacToe
  def initialize
    # instantiate other models here...
  end

  # you may have to refer to the models in this method
  # some of this stuff belongs to the view
  def start_game
     prompt
     user_turn_choice
     initiate_first_player_move
     print_board
  end


  # also some of this stuff belongs to the view
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

  def board_spaces_left
    spaces_left = 0
    board_spaces.each do |k, v|
      spaces_left += 1 if v == " "
    end
    spaces_left
  end
end