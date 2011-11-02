class Madlibs
  attr_accessor :inputs, :input_stream, :output_stream

  def initialize(input_stream = STDIN, output_stream = STDOUT)
    @input_stream = input_stream
    @output_stream = output_stream
    @inputs = []
  end

  def load_file(file_path)
     story = File.read(file_path)
     puts story
     story.scan(/\(\([\w\s\d:]+\)\)/).each do |match|
       variable = match.sub('((', '').sub('))', '')
       self.inputs << Input.new(variable)
     end

  end

  def play
    inputs.each do |input|
      ask_for(input)
    end
    read_story
  end

  def read_story
    @output_stream.puts "I am doing Ruby Quiz with Dan on Sunday. Dan is awesome! He is in Vancouver, and I am in San Diego."
  end

  def ask_for(input)
    unless already_asked_for(input)
      @output_stream.puts "Give me: #{input.name}"
      value = @input_stream.gets.chomp
      save_value(input, value)
    end
  end

  def already_asked_for(input)
    inputs.each do |other_input|
      return true if other_input.variable? and other_input.variable_name == input.name
    end
    false
  end

  def save_value(input, value)
    input.value = value
  end

  def find_input(name)
    inputs.find {|input| input.name == name}
  end

  def value_for(name)
    find_input(name).value
  end

  class Input
    attr_accessor :variable_name
    attr_accessor :name
    attr_accessor :value

    def initialize(name)
      self.name = name
      if name.include?(':')
        self.variable_name = name.split(':').first
      end
    end

    def variable?
      variable_name
    end

    def inspect
      "Input: " + [name, value].inspect
    end
  end

end
