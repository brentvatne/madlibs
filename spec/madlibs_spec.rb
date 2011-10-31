require File.expand_path("../../lib/madlibs", __FILE__) 

describe Madlibs do
  let(:madlibs) { Madlibs.new }

  describe "load_file" do
    it "should populate variables attribute" do
      File.stub!(:read) { "((foo))" }
      madlibs.load_file("sample")
      madlibs.inputs.size.should == 1
      madlibs.inputs.first.name.should == 'foo'
    end

    it "should populate variables attribute" do
      File.stub!(:read) { "((foo:bar))" }
      madlibs.load_file("sample")
      madlibs.inputs.size.should == 1
      madlibs.inputs.first.name.should == 'foo:bar'
      madlibs.inputs.first.variable_name.should == 'foo'
      madlibs.inputs.first.should be_variable
    end
  end

  describe "post load_file" do
    before(:each) do
      madlibs.load_file("spec/sample_data.madlib")
    end

    it "asks the user for a value for each variable" do
      madlibs.inputs.each do |input|
        STDOUT.should_receive(:puts).with(/#{input.name}/)
      end
      madlibs.play
    end

    it "saves the input value for a variable" do
      inputs = StringIO.new("Brad\n")
      madlibs.input_stream = inputs
      madlibs.ask_for(madlibs.find_input("a family member"))
      madlibs.value_for("a family member").should == "Brad"
    end

    it "outputs story with users selected words" do
      File.stub!(:read) { "I am doing Ruby Quiz with ((name: a person)) on Sunday. ((name)) is awesome! He is in ((a city)), and I am in ((another city))." }
      inputs = StringIO.new("Dan\nVancouver\nSan Diego\n")
      outputs = StringIO.new
      madlibs = Madlibs.new(inputs, outputs)
      madibs.play
      outputs.rewind
      outputs.read.should include("I am doing Ruby Quiz with Dan on Sunday. Dan is awesome! He is in Vancouver, and I am in San Diego.")
    end
  end

end
