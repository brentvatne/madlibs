class Madlibs
  attr_accessor :variables

  def load_file(file_path)
    @variables = {:gift => []}
  end

  def inputs
    ["a family member", "an event", "a number",
      "gift:a noun", "an adjective", "gift", "an adjective", "gift", "body part"]
  end

  def play
    inputs.each do |input|
      puts input
    end
  end

  def ask_for(var)
    puts "Give me: #{var}"
    input = gets.chomp
    save_value(var, input)
  end

  def save_value(var, input)
    @variables[var.to_s] = input
  end

  def value_for(var)
    @variables[var.to_s]
  end

end
