require "test_helper"

describe Watcher do
  let(:watcher) { Watcher.new }

  it "must require an email" do
    watcher.valid?.must_equal false
    watcher.errors.must_include :email
  end
end
