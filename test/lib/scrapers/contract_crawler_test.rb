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

  describe "#scrape_contracts" do
    it "should scrape all contracts by default" do
      scraper = Scrapers::ContractCrawler.new
      scraper.stubs(:contract_urls).returns(["http://one.com", "http://two.com", "http://three.com"])
      scraper.expects(:contract_hash).with("http://one.com")
      scraper.expects(:contract_hash).with("http://two.com")
      scraper.expects(:contract_hash).with("http://three.com")
      scraper.scrape_contracts
    end

    it "should scrape only some of the contracts in the list" do
      scraper = Scrapers::ContractCrawler.new
      scraper.stubs(:contract_urls).returns(["http://one.com", "http://two.com", "http://three.com"])
      scraper.expects(:contract_hash).with("http://one.com")
      scraper.expects(:contract_hash).with("http://two.com")
      scraper.scrape_contracts(0..1)
    end
  end
end
