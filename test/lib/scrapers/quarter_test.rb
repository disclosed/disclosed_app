require "test_helper"

describe Scrapers::Quarter do

  describe "#valid?" do
    it "must be valid if the year and quarter are valid" do
      [1, 2, 3, 4].each do |quarter|
        Scrapers::Quarter.new(2010, quarter).valid?.must_equal true
      end
    end

    it "should not be valid if the year is invalid" do
      Scrapers::Quarter.new(2001, 4).valid?.must_equal false
      Scrapers::Quarter.new(2020, 4).valid?.must_equal false
      Scrapers::Quarter.new(nil, 4).valid?.must_equal false
    end

    it "should not be valid if the quarter is invalid" do
      Scrapers::Quarter.new(2010, 0).valid?.must_equal false
      Scrapers::Quarter.new(2010, 5).valid?.must_equal false
      Scrapers::Quarter.new(2010, nil).valid?.must_equal false
    end
  end

  describe "#-" do
    it "should retrieve an earlier quarter" do
      quarter = Scrapers::Quarter.new(2010, 1)
      (quarter - 1).must_equal Scrapers::Quarter.new(2010, 4)
      quarter = Scrapers::Quarter.new(2010, 4)
      (quarter - 1).must_equal Scrapers::Quarter.new(2009, 3)
      quarter = Scrapers::Quarter.new(2009, 3)
      (quarter - 1).must_equal Scrapers::Quarter.new(2009, 2)
      quarter = Scrapers::Quarter.new(2009, 2)
      (quarter - 1).must_equal Scrapers::Quarter.new(2009, 1)
      quarter = Scrapers::Quarter.new(2010, 1)
      (quarter - 8).must_equal Scrapers::Quarter.new(2008, 1)
      quarter = Scrapers::Quarter.new(2010, 1)
      (quarter - 9).must_equal Scrapers::Quarter.new(2008, 4)
    end
  end

  describe "#next" do
    it "should return the quarter following a given quarter" do
      quarter = Scrapers::Quarter.new(2010, 1)
      quarter.next.must_equal Scrapers::Quarter.new(2010, 2)
      quarter.next.next.must_equal Scrapers::Quarter.new(2010, 3)
    end
  end

  describe "::latest" do
    it "should retrieve the latest quarter" do
      Timecop.freeze(Time.local(2010, 1, 1))
      Scrapers::Quarter.latest.must_equal Scrapers::Quarter.new(2010, 4)
      Timecop.freeze(Time.local(2010, 10, 1))
      Scrapers::Quarter.latest.must_equal Scrapers::Quarter.new(2010, 3)
      Timecop.freeze(Time.local(2010, 7, 1))
      Scrapers::Quarter.latest.must_equal Scrapers::Quarter.new(2010, 2)
      Timecop.freeze(Time.local(2010, 4, 1))
      Scrapers::Quarter.latest.must_equal Scrapers::Quarter.new(2010, 1)
      Timecop.return
    end
  end

  describe "::parse" do
    it "should create a quarter based on a string" do
      quarter = Scrapers::Quarter.parse("2013q1")
      quarter.year.must_equal 2013
      quarter.quarter.must_equal 1
    end

    it "should raise an error if the quarter string is invalid" do
      proc {Scrapers::Quarter.parse("asdfasd")}.must_raise ArgumentError
    end
  end

end
