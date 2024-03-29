class Madlibs
  attr_accessor :inputs, :input_stream, :output_stream, :story

  def initialize(input_stream = STDIN, output_stream = STDOUT)
    @input_stream = input_stream
    @output_stream = output_stream
    @inputs = []
  end

  def load_file(file_path)
    @story = File.read(file_path)

    @story.scan(/\(\([\w\s\d:]+\)\)/).each do |match|
      variable = match.sub('((', '').sub('))', '')
      inputs << Input.new(variable)
    end

    self
  end

  def with_each_input
    inputs.each do |input|
      yield(input) if block_given?
    end
  end

  def play
    with_each_input { |input| find_value_for(input) }
    read_story
  end

  def find_value_for(input)
    value = already_asked_for?(input) ? value_for(input) : ask_for(input)
    save_value(input, value)
  end

  def ask_for(input)
    output_stream.puts "Give me: #{input.display_name}"
    value = input_stream.gets.chomp
  end

  def read_story
    story_with_input = story
    with_each_input do |input|
      story_with_input = story_with_input.gsub("(("+input.name+"))", input.value)
    end
    output_stream.puts story_with_input
  end

  def already_asked_for?(input)
    with_each_input do |other_input|
      return true if (other_input.variable? and other_input.variable_name == input.name)
    end
    false
  end

  def save_value(input, value)
    input.value = value
  end

  def find_input(name)
    inputs.find do |input|
      input.name == name || input.variable_name == name
    end
  end

  def value_for(input)
    find_input(input.name).value
  end

  class Input
    attr_accessor :variable_name, :name, :value

    def initialize(name)
      self.name = name
      if name.include?(':')
        self.variable_name = name.split(':').first
      end
    end

    def display_name
      if self.variable?
        name.split(':').last.strip
      else
        name
      end
    end

    def variable?
      variable_name
    end

    #not necessary anymore but cool idea to overwrite inspect for debugging
    def inspect
      "Input: " + [name, value].inspect
    end
  end

end

# m = Madlibs.new.load_file("spec/sample_data.madlib").play
