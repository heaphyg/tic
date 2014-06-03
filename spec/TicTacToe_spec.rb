require_relative 'spec_helper'


describe "TicTacToe" do
  context "#get_cpu_piece" do
    tic_tac_toe = TicTacToe.new
    it "assigns the opposing piece to the cpu based on the user's selection" do
      expect(tic_tac_toe.get_cpu_piece('X')).to eq('O')
    end
  end
end


#########################################################

# def get_cpu_piece(user_piece)
#     user_piece == 'X' ? 'O' : 'X'
# end

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