require_relative 'spec_helper'

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
