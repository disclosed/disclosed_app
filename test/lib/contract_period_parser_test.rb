
require "test_helper"

describe ContractPeriodParser do

  describe "::extract_dates" do
    it "should extract dates that look like 2014-01-01" do
      contract_period = ContractPeriodParser.new("2004-06-14 to 2005-02-28")
      contract_period.parse
      contract_period.start_date.must_equal Date.parse("2004-06-14")
      contract_period.end_date.must_equal Date.parse("2005-02-28")
      contract_period = ContractPeriodParser.new("2013-10-20to 2014-10-18")
      contract_period.parse
      contract_period.start_date.must_equal Date.parse("2013-10-20")
      contract_period.end_date.must_equal Date.parse("2014-10-18")
      contract_period = ContractPeriodParser.new("2013-10-20to2014-10-18")
      contract_period.parse
      contract_period.start_date.must_equal Date.parse("2013-10-20")
      contract_period.end_date.must_equal Date.parse("2014-10-18")
    end

    it "should extract dates that look like Jan 1, 2014" do
      contract_period = ContractPeriodParser.new("October 20th, 2013 to October 18th, 2014")
      contract_period.parse
      contract_period.start_date.must_equal Date.parse("2013-10-20")
      contract_period.end_date.must_equal Date.parse("2014-10-18")
    end

    it "should extract dates that have a french language divider" do
      contract_period = ContractPeriodParser.new("2013-10-20 &agrave; 2014-10-18")
      contract_period.parse

      contract_period.start_date.must_equal Date.parse("2013-10-20")
      contract_period.end_date.must_equal Date.parse("2014-10-18")
    end

    it "should extract dates where only the start date is given" do
      contract_period = ContractPeriodParser.new("2013-10-20")
      contract_period.parse
      contract_period.start_date.must_equal Date.parse("2013-10-20")
      contract_period.end_date.must_equal nil
    end

    it "should return nil dates if there is no contract period" do
      contract_period = ContractPeriodParser.new(nil)
      contract_period.parse
      contract_period.start_date.must_equal nil
      contract_period.end_date.must_equal nil
      contract_period = ContractPeriodParser.new("")
      contract_period.parse
      contract_period.start_date.must_equal nil, nil
      contract_period.end_date.must_equal nil
      contract_period = ContractPeriodParser.new("  \n")
      contract_period.parse
      contract_period.end_date.must_equal nil
    end

    it "should be invalid if the date string is invalid" do
      contract_period = ContractPeriodParser.new("All your base are belong to us")
      contract_period.parse
      contract_period.valid?.must_equal false
    end
  end
end
