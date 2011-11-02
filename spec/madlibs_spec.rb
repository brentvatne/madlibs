require File.expand_path("../../lib/madlibs", __FILE__) 

describe Madlibs do
  let(:madlibs) { Madlibs.new }

  describe "load_file" do
    it "should populate variables attribute" do
      File.stub!(:read) { "((foo))" }
      madlibs.load_file("a.madlib")
      madlibs.inputs.size.should == 1
      madlibs.inputs.first.name.should == 'foo'
    end

    it "should populate variables attribute" do
      File.stub!(:read) { "((foo:bar))" }
      madlibs.load_file("a.madlib")
      madlibs.inputs.size.should == 1
      madlibs.inputs.first.name.should == 'foo:bar'
      madlibs.inputs.first.variable_name.should == 'foo'
      madlibs.inputs.first.should be_variable
    end
  end

  describe "post load_file" do
    let(:inputs) { StringIO.new("\n "*20) }
    let(:outputs) { StringIO.new }

    before(:each) do
      madlibs.input_stream = inputs
      madlibs.output_stream = outputs
      madlibs.load_file("spec/sample_data.madlib")
    end

    it "leaves the variable name out of the question" do
      File.stub!(:read) { "I am doing Ruby Quiz with ((name: a person)) on Sunday. ((name)) is awesome! He is in ((a city)), and I am in ((another city))." }
      madlibs = Madlibs.new(inputs, outputs)
      madlibs.load_file("a.madlib").play

      outputs.rewind
      outputs.read.scan(/name: a person/).size.should == 0
    end

    it "saves the input value for a variable" do
      inputs = StringIO.new("Brad\n")
      madlibs.input_stream = inputs
      a_lib = madlibs.find_input("a family member")
      madlibs.find_value_for(a_lib)
      madlibs.value_for(a_lib).should == "Brad"
    end

    it "outputs story with users selected words" do
      File.stub!(:read) { "I am doing Ruby Quiz with ((name: a person)) on Sunday. ((name)) is awesome! He is in ((a city)), and I am in ((another city))." }
      inputs = StringIO.new("Dan\nVancouver\nSan Diego\n")
      madlibs = Madlibs.new(inputs, outputs)
      madlibs.load_file("a.madlib").play

      outputs.rewind
      outputs.read.should include("I am doing Ruby Quiz with Dan on Sunday. Dan is awesome! He is in Vancouver, and I am in San Diego.")
    end
  end

end
