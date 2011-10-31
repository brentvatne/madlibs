class Madlibs
  attr_accessor :inputs, :input_stream, :output_stream

  def initialize(input_stream = STDIN, output_stream = STDOUT)
    @input_stream = input_stream
    @output_stream = output_stream
    @inputs = []
  end

  def load_file(file_path)
     story = File.read(file_path)
     story.scan(/\(\([\w\s\d:]+\)\)/).each do |match|
       variable = match.sub('((', '').sub('))', '')
       self.inputs << Input.new(variable)
     end

  end

  def play
    inputs.each do |input|
      ask_for(input)
    end
  end

  def ask_for(input)
    puts "Give me: #{input.name}"
    value = @input_stream.gets.chomp
    save_value(input, value)
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
