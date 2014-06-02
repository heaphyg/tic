class User
  attr_accessor :user_name, :user_piece
  def initialize
    @user_name = nil
    @user_piece = nil 
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
        puts "#{user_name} you have chosen to go second. Bold move. Please select the number of the space you wish to occupy."
        proper_piece_selection = true
        self.cpu_piece = 'X'
      end
    end
  end

  def initiate_first_player_move
    user_piece == 'X' ? user_turn : cpu_turn
  end

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

  def wrong_move
    puts "You must choose an empty space"
    user_turn
  end

  def incorrect_input
    puts "Please specify a move with an integer 1..9"
    user_turn
  end
end