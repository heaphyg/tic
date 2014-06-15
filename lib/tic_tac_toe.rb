require_relative 'ai'
require_relative 'user'
require_relative 'board'

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

  def get_user_name
    return gets.chomp.split(" ").map { |word| word.capitalize }.join(" ")
  end

  
  def get_user_piece
    selection = nil
    border
    until ['X','O'].include?(selection)
      puts "#{user.name} please write an 'X' if you would like to go first or an 'O' if you would like to go second."
      selection = gets.chomp.upcase
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

  def user_turn
    print_board
    input = gets.chomp
    if (1..9).include?(input.to_i)
      input = input.to_i
      if board.board_spaces[input] == " "
        board.board_spaces[input] = user.piece
        check_game(ai.piece)
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

  def check_game(next_turn)
    unless game_over?
      if(board_spaces_left > 0)
        if(next_turn == user.piece)
          user_turn 
        else
          cpu_turn   
        end
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
