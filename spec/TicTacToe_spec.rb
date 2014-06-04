## to run tests run: gem install rspec-expectations
require_relative 'spec_helper'
require 'stringio'

describe "Board" do
  let(:board) { Board.new }
  context "#board_spaces" do
    it "returns a hash representing the state of the board" do
       expect(board.board_spaces).to be == { 
          1 => " ",2 => " ",3 => " ",
          4 => " ",5 => " ",6 => " ",
          7 => " ",8 => " ",9 => " "
       }
    end
  end

  context "#potential_victory_scenarios" do
    it "returns a nested array of victory_scenario arrays" do
      expect(board.potential_victory_scenarios).to be ==
        [ 
          [1,2,3], 
          [4,5,6], 
          [7,8,9],
          [1,4,7],
          [2,5,8],
          [3,6,9],
          [1,5,9], 
          [3,5,7]
        ]
    end
  end
end



describe "AI" do
  let(:board) { Board.new }
  let(:user)  { User.new }
  let(:ai)   { AI.new(board, user) }
  
  context "#scenario_spaces_analysis(scenario)" do
    before do
        board.board_spaces = { 
          1 => "X",2 => " ",3 => " ",
          4 => " ",5 => "O",6 => " ",
          7 => " ",8 => " ",9 => "X"
        }  
    end

    it "returns the board state associated with a particular victory scenario" do
      expect(ai.scenario_spaces_analysis([1,5,9])).to be == ['X', 'O', 'X']
    end
  end

  context "#piece_count_for_scenario(scenario, player_piece) - not occupied by opponent " do
    before do
        board.board_spaces = { 
          1 => "X",2 => " ",3 => " ",
          4 => " ",5 => " ",6 => " ",
          7 => " ",8 => " ",9 => "X"
        }  
    end

    it "it returns the current players piece count when the scenario is not occupied by opponent" do
      expect(ai.piece_count_for_scenario([1,5,9], "X")).to be == 2
    end
  end

  context "#piece_count_for_scenario(scenario, player_piece) - occupied by opponent " do
    before do
        board.board_spaces = { 
          1 => "X",2 => " ",3 => " ",
          4 => " ",5 => "O",6 => " ",
          7 => " ",8 => " ",9 => "X"
        }  
    end

    it "it returns 0 when the scenario is occupied by opponent" do
      expect(ai.piece_count_for_scenario([1,5,9], "X")).to be == 0
    end
  end

  context "#find_empty_spaces_in_victory_scenario(victory_scenario)" do
    before do
        board.board_spaces = { 
          1 => "X",2 => " ",3 => " ",
          4 => " ",5 => "O",6 => " ",
          7 => " ",8 => " ",9 => "X"
        }  
    end

    it "returns a random empty spaces from a particular victory_scenario" do
      expect(ai.find_empty_spaces_in_victory_scenario([1,4,7])).not_to be == 1
    end
  end

  context "#seek_victory - true" do
    before do
        ai.piece = "O"
        board.board_spaces = { 
          1 => "X",2 => " ",3 => " ",
          4 => " ",5 => "O",6 => " ",
          7 => "O",8 => " ",9 => "X"
        }  
    end
    it "returns the space to be filled in order to achieve victory" do
      expect(ai.seek_victory).to be == 3
    end
  end

  context "#seek_victory - false" do
    before do
        ai.piece = "O"
        board.board_spaces = { 
          1 => "X",2 => " ",3 => " ",
          4 => " ",5 => " ",6 => " ",
          7 => "O",8 => " ",9 => "X"
        }  
    end
    it "returns false when there are no victory scenarios with 2 A.I pieces" do
      expect(ai.seek_victory).to be == false
    end
  end

  context "#block_victory - true" do
      before do
        user.piece = "X"
        board.board_spaces = { 
          1 => "X",2 => " ",3 => " ",
          4 => " ",5 => "X",6 => " ",
          7 => "O",8 => " ",9 => " "
        }  
    end
    it "blocks the user from a potential victory" do
      expect(ai.block_victory).to be == 9
    end
  end

  context "#block_victory - false" do
      before do
        user.piece = "X"
        board.board_spaces = { 
          1 => "X",2 => " ",3 => " ",
          4 => " ",5 => " ",6 => " ",
          7 => " ",8 => " ",9 => " "
        }  
    end
    it "returns false when there are no victory scenarios with 2 the user's pieces" do
      expect(ai.block_victory).to be == false
    end
  end

  context "#middle_tactic - true" do
    before do
        board.board_spaces = { 
          1 => "X",2 => " ",3 => " ",
          4 => " ",5 => " ",6 => " ",
          7 => " ",8 => " ",9 => " "
        }  
    end

    it "returns 5 (the middle space) when any of the corners are occupied && 5 is empty" do
      expect(ai.middle_tactic).to be == 5
    end
  end

   context "#middle_tactic - false" do
    before do
        board.board_spaces = { 
          1 => " ",2 => " ",3 => " ",
          4 => "X",5 => " ",6 => " ",
          7 => " ",8 => " ",9 => " "
        }  
    end

    it "returns false when no corners are occupied" do
      expect(ai.middle_tactic).to be == false
    end
  end

  context "#middle_tactic - false" do
    before do
        board.board_spaces = { 
          1 => " ",2 => " ",3 => " ",
          4 => " ",5 => "X",6 => " ",
          7 => " ",8 => " ",9 => " "
        }  
    end

    it "returns false when the middle is occupied" do
      expect(ai.middle_tactic).to be == false
    end
  end

  context "#corner_tactic - true" do
    before do
        board.board_spaces = { 
          1 => " ",2 => " ",3 => " ",
          4 => " ",5 => "X",6 => " ",
          7 => " ",8 => " ",9 => " "
        }  
    end

    it "it occupies a random corner when all corners are empty and the middle is occupied" do
      [ai.corner_tactic].should_not include(2,4,6,8)
    end
  end

  context "#corner_tactic - false" do
    before do
        board.board_spaces = { 
          1 => " ",2 => " ",3 => " ",
          4 => " ",5 => " ",6 => " ",
          7 => "X",8 => " ",9 => " "
        }  
    end

    it "it returns false if any of the coners are occupied" do
      expect(ai.corner_tactic).to be == false
    end
  end

  context "#corner_tactic - false" do
    before do
        board.board_spaces = { 
          1 => " ",2 => " ",3 => " ",
          4 => " ",5 => " ",6 => " ",
          7 => " ",8 => " ",9 => " "
        }  
    end

    it "it returns false if no conrners are occupied" do
      expect(ai.corner_tactic).to be == false
    end
  end

  context "#build_up_a_victory_scenario - true" do
    before do
        ai.piece = 'X'
        board.board_spaces = { 
          1 => " ",2 => " ",3 => " ",
          4 => " ",5 => "O",6 => " ",
          7 => "X",8 => "O",9 => " "
        }  
    end

    it "it returns a random empty space from one of the possible victory scenarios" do
      [ai.build_up_a_victory_scenario].should_not include(2,3,6,9)
    end
  end

  context "#build_up_a_victory_scenario - false" do
    before do
        ai.piece = 'X'
        board.board_spaces = { 
          1 => " ",2 => " ",3 => " ",
          4 => "O",5 => "X",6 => " ",
          7 => "X",8 => "O",9 => "O"
        }  
    end

    it "it returns false when there are no potential victory scenarios to build up" do
      expect(ai.build_up_a_victory_scenario).to be == false
    end
  end

  context "#find_all_empty_spaces" do
    before do
        ai.piece = 'X'
        board.board_spaces = { 
          1 => " ",2 => " ",3 => " ",
          4 => "O",5 => "X",6 => " ",
          7 => "X",8 => "O",9 => "O"
        }  
    end

    it "it returns an array of all the empty locations on the board" do
      expect(ai.find_all_empty_spaces).to be == [1,2,3,6]
    end
  end

  context "#select_random_location" do
    before do
        ai.piece = 'X'
        board.board_spaces = { 
          1 => " ",2 => " ",3 => " ",
          4 => "O",5 => "X",6 => " ",
          7 => "X",8 => "O",9 => "O"
        }  
    end

    it "it returns a randomly selected value from find_all_empty_spaces" do
      [ai.select_random_location].should_not include(4,5,7,8,9)
    end
  end
end


describe "TicTacToe" do
  let(:tic_tac_toe) { TicTacToe.new }

  context "#get_user_name" do
    before do
      $stdin = StringIO.new("john smith\n")
    end
    after do
      $stdin = STDIN
    end

    it "returns the capitalized version user's inputed name" do
      expect(tic_tac_toe.get_user_name).to be == 'John Smith'
    end
  end

  context "#get_user_piece (X)" do
    before do
      $stdin = StringIO.new("X\n")
    end
    after do
      $stdin = STDIN
    end

    it "returns X when the user types X" do
       expect(tic_tac_toe.get_user_piece).to be == 'X'
    end
  end
  
  context "#get_user_piece (O)" do
    before do
      $stdin = StringIO.new("O\n")
    end
    after do
      $stdin = STDIN
    end
    
    it "returns O when the User types O" do
      expect(tic_tac_toe.get_user_piece).to be == 'O'
    end
  end

  context "#get_cpu_piece" do
    it "assigns the opposing piece to the A.I based on the user's selection" do
      expect(tic_tac_toe.get_cpu_piece('X')).to eq('O')
    end
  end

  context "#board_spaces_left" do
    before do
        tic_tac_toe.board.board_spaces = { 
          1 => " ",2 => " ",3 => " ",
          4 => "O",5 => "X",6 => " ",
          7 => "X",8 => "O",9 => "O"
        }  
    end

    it "it returns the number of empty spaces left on the board" do
      expect(tic_tac_toe.board_spaces_left).to be == 4
    end
  end

  context "#board_spaces_left" do
    before do
        tic_tac_toe.board.board_spaces = { 
          1 => "X",2 => "O",3 => "O",
          4 => "O",5 => "X",6 => "X",
          7 => "X",8 => "O",9 => "O"
        }  
    end

    it "it returns the number of empty spaces left on the board" do
      expect(tic_tac_toe.board_spaces_left).to be == 0
    end
  end

  context "#game_over - A.I wins" do
    before do
        tic_tac_toe.ai.piece = "X"
        tic_tac_toe.user.piece = "O"
        tic_tac_toe.board.board_spaces = { 
          1 => "X",2 => "O",3 => "X",
          4 => "O",5 => "X",6 => "X",
          7 => "X",8 => "O",9 => "O"
        }  
    end

    it "should return true when the A.I wins" do
      expect(tic_tac_toe.game_over?).to be == true
    end
  end

  context "#game_over - User wins" do
    before do
        tic_tac_toe.user.piece = "O"
        tic_tac_toe.ai.piece = "X"
        tic_tac_toe.board.board_spaces = { 
          1 => "O",2 => "O",3 => "O",
          4 => "O",5 => "X",6 => "X",
          7 => "X",8 => "O",9 => "X"
        }  
    end

    it "should return true when the user wins" do
      expect(tic_tac_toe.game_over?).to be == true
    end
  end

  context "#game_over - no winner" do
    before do
        tic_tac_toe.user.piece = "O"
        tic_tac_toe.ai.piece = "X"
        tic_tac_toe.board.board_spaces = { 
          1 => "X",2 => "X",3 => "O",
          4 => "O",5 => "O",6 => "X",
          7 => "X",8 => "X",9 => "O"
        }  
    end

    it "should return false when there is no winner" do
      expect(tic_tac_toe.game_over?).to be == false
    end
  end
end

