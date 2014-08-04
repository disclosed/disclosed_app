require "test_helper"

describe Scrapers::ContractCrawler do
  describe "#new" do
    it "should scrape the most recent quarter by default" do
      scraper = Scrapers::ContractCrawler.new
      scraper.instance_variable_get(:@quarter).must_equal Scrapers::Quarter.latest
    end

    it "should scrape starting a few quarters ago" do
      y2013q4 = Scrapers::Quarter.new(2013, 4)
      scraper = Scrapers::ContractCrawler.new(y2013q4)
      scraper.instance_variable_get(:@quarter).must_equal y2013q4
    end
  end
end
