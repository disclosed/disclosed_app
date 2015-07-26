require "test_helper"

describe ScraperNotifier do

  before do
    @notifier = ScraperNotifier.new
  end

  describe "#on" do
    it "should register a callback" do
      my_code = -> (args) { puts "hello" }
      @notifier.on(:foo, my_code)
      @notifier.instance_variable_get(:@callbacks).must_equal(foo: [my_code])
    end

    it "should be able to register more than one callback for the same event" do
      my_code = -> (args) { puts "hello" }
      my_other_code = -> (args) { puts "bye" }
      @notifier.on(:foo, my_code)
      @notifier.on(:foo, my_other_code)
      @notifier.instance_variable_get(:@callbacks).must_equal(foo: [my_code, my_other_code])
    end
  end

  describe "#trigger" do
    it "should trigger an event to all registered callbacks" do
      my_code = -> (args) { puts "hello" }
      my_code.expects(:call).with(["lalala"]).twice
      @notifier.on(:foo, my_code)
      @notifier.on(:foo, my_code)
      @notifier.trigger(:foo, "lalala")
    end
  end

end
