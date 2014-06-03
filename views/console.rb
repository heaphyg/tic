class Console
  def initialize
  end

  def run_program
  end

  def prompt
    puts "Welcome to Tic Tac Toe!"
    puts "what is your name?"
    self.user_name = gets.chomp.capitalize
    return user_name
  end

  
end