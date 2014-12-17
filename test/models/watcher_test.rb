require "test_helper"

describe Watcher do
  let(:watcher) { Watcher.new }

  it "must be valid" do
    watcher.must_be :valid?
  end
end
