require File.expand_path("../../lib/madlibs", __FILE__) 

describe Madlibs do

  before(:each) do
    @madlibs = Madlibs.new
    @madlibs.load_file("sample_data.madlib")
  end

  it "extracts all variables from a madlibs document" do
    @madlibs.inputs.should == ["a family member", "an event", "a number",
      "gift:a noun", "an adjective", "gift", "an adjective", "gift", "body part"]
  end

  it "identifies reusable inputs as variables" do
    @madlibs.variables.keys.should include(:gift)
  end

  it "opens and reads the story template from a .madlib file" do
    pending "do this after, use the alternate_sample_data.madlib file to
             break the previous two tests"
  end

  it "asks the user for a value for each variable" do
    @madlibs.inputs.each do |input|
      STDOUT.should_receive(:puts).with(/#{input}/)
    end
    @madlibs.play
  end

  it "saves the input value for a variable" do
    @madlibs.stub!(:gets) { "Brad" }
    @madlibs.ask_for("a family member")
    @madlibs.value_for("a family member").should == "Brad"
  end

  # it "outputs story with users selected words" do
  #   @madlibs.set_word "a family member", "Brad"
  #   @madlibs.set_word "an event", "birthday"
  #   @madlibs.set_word "a number", "12"
  #   @madlibs.set_word "gift:a noun", "12"
  #   @madlibs.read_story.should == 
  # end

end
