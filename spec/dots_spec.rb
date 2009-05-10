require "spec/mocks"
$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__) + "/../lib")
require "dots"
include Enumerable # To bring 1.8.7's Enumerator top-level.

def enumerator?
  RUBY_VERSION >= "1.8.7"
end

describe Dots do
  it 'should be configurable for "."' do
    Dots["."].should == "."
    proc { Dots["."] = ":)" }.should_not raise_error
    Dots["."].should == ":)"
  end

  it 'should be configurable for "F"' do
    Dots["F"].should == "F"
    proc { Dots["F"] = ":|" }.should_not raise_error
    Dots["F"].should == ":|"
  end

  it 'should be configurable for "E"' do
    Dots["E"].should == "E"
    proc { Dots["E"] = ":(" }.should_not raise_error
    Dots["E"].should == ":("
  end

  it 'should not be configurable for anything else' do
    proc { Dots["A"] }.should raise_error(Dots::InvalidDot)
    proc { Dots["A"] = ":D" }.should raise_error(Dots::InvalidDot)
  end
end

describe "Monkey-patched" do
  describe "Enumerable.instance_methods" do
    it do
      Enumerable.instance_methods.should include("each_with_dots")
    end
  end

  describe "Enumerator.instance_methods" do
    it do
      Enumerator.instance_methods.should include("with_dots")
    end
  end if enumerator?

  describe "Kernel.methods" do
    it do
      Kernel.private_instance_methods.should include("dots")
    end
  end
end

describe "each_with_dots" do
  before :each do
    @enumerated = 1..5
    @io = StringIO.new
    @proc = Proc.new {}
  end

  after :each do
    @enumerated.each_with_dots @io, &@proc
  end

  it "should synchronize standard output" do
    @io.should_receive(:sync=).twice
  end

  it 'should receive print dots' do
    Dots.should_receive(:[]).exactly(5).times.with "."
  end

  it 'should receive print Fs' do
    @proc = Proc.new { |n| raise }
    Dots.should_receive(:[]).exactly(5).times.with "F"
  end

  it 'should receive print Es' do
    @proc = Proc.new { |n| n / 0 }
    Dots.should_receive(:[]).exactly(5).times.with "E"
  end

  it "should track the time" do
    Time.should_receive :now
  end

  it 'should receive "report"' do
    Dots.should_receive :report
  end
end

describe "each.with_dots" do
  before :each do
    @it = (1..5).each
  end

  it do
    @it.with_dots.should be_an(Enumerator)
  end

  it 'should receive "enum_for" with "each_with_dots"' do
    @io = StringIO.new
    @it.should_receive(:enum_for).with(:each_with_dots, @io).and_return @it
    @it.with_dots(@io) {}.should == (1..5)
  end
end if enumerator?

describe "with_dots" do
  it "should print dots" do
    Dots.should_receive(:[]).with "."
    dots(1, StringIO.new) {}
  end

  it "should require a block" do
    proc { dots }.should raise_error(LocalJumpError)
  end

  it "should synchronize standard output" do
    io = StringIO.new
    io.should_receive(:sync=).twice
    dots(1, io) {}
  end

  it "should spin up and kill a thread" do
    thread = mock "thread"
    Thread.should_receive(:new).and_return thread
    thread.should_receive :kill
    dots(1, StringIO.new) {}
  end
end
