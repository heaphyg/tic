require_relative 'spec_helper'

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

