require_relative 'spec_helper'
require 'stringio'


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
    it "assigns the opposing piece to the cpu based on the user's selection" do
      expect(tic_tac_toe.get_cpu_piece('X')).to eq('O')
    end
  end

  # context "#initiate_first_player_move (when X is selected by user)" do
  #   before do
  #     user = User.new
  #     user.piece = 'X'
  #   end

  #   it "runs #user_turn" do
  #      expect(tic_tac_toe.initiate_first_player_move).to eq(tic_tac_toe.user_turn)
  #   end
  # end

  # context "#initiate_first_player_move (when O is selected by user)" do
  #   before do
  #     user = User.new
  #     user.piece = 'O'
  #   end

  #   it "runs #user_turn" do
  #      expect(tic_tac_toe.initiate_first_player_move).to eq(tic_tac_toe.cpu_turn)
  #   end
  # end

#   context "#border" do
#     it "prints out a border made up of asterisks" do
#       output = tic_tac_toe.border
#       output.should == "*************************************************************************"
#       # expect(tic_tac_toe.border).to be == "*************************************************************************"
#     end
#   end
end

# it "should say 'Hello from Rspec' when run" do        
#   output = `ruby sayhello.rb`
#   output.should == 'Hello from RSpec'   
# end


# describe "sayhello.rb" do
#   it "should say 'Hello from Rspec' when ran" do        
#     STDOUT.should_receive(:puts).with('Hello from RSpec')
#     require_relative 'sayhello.rb' #load/run the file 
#   end
# end

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


 


#########################################################


# require "spec_helper"

# describe LongUrl do
#   context "when generating long urls" do
#     context "#generate_long_url" do
#       it "generates long urls with 2000 characters" do
#         long_url = LongUrl.new
#         expect(long_url.generate_long_url).to have(2000).characters
#       end
#     end
    
#     it "sets generated long url when saving" do
#       long_url = LongUrl.new
#       long_url.stub(:generate_long_url => "ryan is awesome")
#       long_url.save
#       expect(long_url.long_url).to eq("ryan is awesome")
#     end
#   end
# end

describe "CPU" do
  let(:board) { Board.new }
  let(:user)  { User.new }
  let(:cpu)   { CPU.new(board, user) }
  
  context "#scenario_spaces_analysis(scenario)" do
    before do
        board.board_spaces = { 
          1 => "X",2 => " ",3 => " ",
          4 => " ",5 => "O",6 => " ",
          7 => " ",8 => " ",9 => "X"
        }  
    end

    it "returns the board state associated with a particular victory scenario" do
      expect(cpu.scenario_spaces_analysis([1,5,9])).to be == ['X', 'O', 'X']
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
      expect(cpu.piece_count_for_scenario([1,5,9], "X")).to be == 2
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
      expect(cpu.piece_count_for_scenario([1,5,9], "X")).to be == 0
    end
  end
end

 # def find_empty_spaces_in_victory_scenario(victory_scenario)
 #    victory_scenario.select {|space| board.board_spaces[space] == " "}.sample
 #  end