require_relative 'spec_helper'

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

    it "returns the current players piece count when the scenario is not occupied by opponent" do
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

    it "returns 0 when the scenario is occupied by opponent" do
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

    it "occupies a random corner when all corners are empty and the middle is occupied" do
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

    it "returns false if any of the coners are occupied" do
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

    it "returns false if no conrners are occupied" do
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

    it "returns a random empty space from one of the possible victory scenarios" do
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

    it "returns false when there are no potential victory scenarios to build up" do
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

    it "returns an array of all the empty locations on the board" do
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

    it "returns a randomly selected value from find_all_empty_spaces" do
      [ai.select_random_location].should_not include(4,5,7,8,9)
    end
  end

  context "#start_in_corner" do
    before do
        ai.piece = 'X'
        board.board_spaces = { 
          1 => " ",2 => " ",3 => " ",
          4 => "O",5 => "X",6 => " ",
          7 => "X",8 => "O",9 => "O"
        } 
    end 


    it "returns a randomly selected corner that is empty" do
      [ai.start_in_corner].should_not include(2,4,5,6,7,8,9)
    end
  end

   context "#start_in_corner -false" do
    before do
        ai.piece = 'X'
        board.board_spaces = { 
          1 => "X",2 => " ",3 => "O",
          4 => "O",5 => "X",6 => " ",
          7 => "X",8 => "O",9 => "O"
        } 
    end 


    it "returns no corners when there are no empty corners" do
      [ai.start_in_corner].should_not include(1,2,3,4,5,6,7,8,9)
    end
  end

  context "#diagnal_defense" do
    before do
        ai.piece = 'X'
        board.board_spaces = { 
          1 => "X",2 => " ",3 => " ",
          4 => " ",5 => "X",6 => " ",
          7 => " ",8 => " ",9 => "O"
        } 
    end 


    it "returns a randomly slected empty corner when two of the 4 corners are occupied" do
      [ai.diagnal_defense].should_not include(1,2,4,5,8,9)
    end
  end

  context "#diagnal_defense- false" do
    before do
        ai.piece = 'X'
        board.board_spaces = { 
          1 => "X",2 => " ",3 => "O",
          4 => " ",5 => "X",6 => " ",
          7 => " ",8 => " ",9 => "O"
        } 
    end 


    it "returns no empty corner when more than two of the 4 corners are occupied" do
      [ai.diagnal_defense].should_not include(1,2,3,4,5,6,7,8,9)
    end
  end

  context "#diagnal_defense- false" do
    before do
        ai.piece = 'X'
        board.board_spaces = { 
          1 => " ",2 => " ",3 => " ",
          4 => " ",5 => "X",6 => " ",
          7 => " ",8 => " ",9 => "O"
        } 
    end 


    it "returns no empty corner when less than two of the 4 corners are occupied" do
      [ai.diagnal_defense].should_not include(1,2,3,4,5,6,7,8,9)
    end
  end




end



 # def diagnal_defense
 #    puts "diagonal DEF"
 #    if empty_corners(corner_scenario).length == 2
 #      return empty_corners(corner_scenario).sample
 #    end
 #  end