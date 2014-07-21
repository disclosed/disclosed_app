require "test_helper"
describe Scrapers::DfoScraper do

  it "should scrape the most recent quarter by default" do
    scraper = Scrapers::DfoScraper.new
    scraper.expects(:scrape_quarter).with(Scrapers::Quarter.latest).returns(nil)
    scraper.scrape
  end

  it "should scrape starting a few quarters ago" do
    y2013q4 = Scrapers::Quarter.new(2013, 4)
    scraper = Scrapers::DfoScraper.new
    scraper.expects(:scrape_quarter).with(y2013q4).returns(nil)
    scraper.scrape(y2013q4)
  end

  describe "scrape real requests" do

    it "should find some contracts in 2013 Q4" do
      skip("still working on the scraper api")
      VCR.use_cassette('dfo_2013_q4') do
        y2013q4 = Scrapers::Quarter.new(2013, 4)
        scraper = Scrapers::DfoScraper.new
        scraper.stubs(:contract_urls).returns([
          "http://www.dfo-mpo.gc.ca/PD-CP/details_e.asp?f=2013q4&r=F4748-120002",
          "http://www.dfo-mpo.gc.ca/PD-CP/details_e.asp?f=2013q4&r=F2599-120291"
        ])
        scraper.scrape(y2013q4)
        Contract.length.must_eql 2
      end
    end
  end
end
