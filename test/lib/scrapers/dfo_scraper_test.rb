require "test_helper"
describe Scrapers::DfoScraper do

  before do
    Agency.create(name: "Department of Fisheries and Oceans", abbr: "dfo")
  end

  describe "#scrape" do
    it "should scrape the most recent quarter by default" do
      scraper = Scrapers::DfoScraper.new
      scraper.expects(:contract_urls).with(Scrapers::Quarter.latest).returns([])
      scraper.scrape
    end

    it "should scrape starting a few quarters ago" do
      y2013q4 = Scrapers::Quarter.new(2013, 4)
      scraper = Scrapers::DfoScraper.new
      scraper.expects(:contract_urls).with(y2013q4).returns([])
      scraper.scrape(y2013q4)
    end
  end

  describe "#contract_urls" do
    it "should find all the contract urls for a quarter" do
      VCR.use_cassette('contract_urls_y2013_q1') do
        y2013q1 = Scrapers::Quarter.new(2013, 4)
        scraper = Scrapers::DfoScraper.new
        scraper.contract_urls(y2013q1)
      end
    end

    it "should parse the data from a contract page" do
      VCR.use_cassette('dfo_2013_q4') do
        y2013q4 = Scrapers::Quarter.new(2013, 4)
        scraper = Scrapers::DfoScraper.new
        scraper.stubs(:contract_urls).returns([
          "http://www.dfo-mpo.gc.ca/PD-CP/details_e.asp?f=2013q4&r=F4748-120002"
        ])
        scraper.scrape(y2013q4)
        contract = Contract.first
        contract.vendor_name.must_equal "DOCULIBRE INC"
        contract.reference_number.must_equal "F4748-120002"
        contract.effective_date.must_equal Date.parse("2013-01-01")
        contract.start_date.must_equal Date.parse("2013-01-01")
        contract.end_date.must_equal Date.parse("2013-03-31")
        contract.url.must_equal "http://www.dfo-mpo.gc.ca/PD-CP/details_e.asp?f=2013q4&r=F4748-120002"
        contract.value.must_equal 9500
        contract.description.must_equal "{\"main\":\"0473 Information Technology and Telecommunications Consultantss\",\"regional_office\":\"Gulf\",\"contact_phone\":\"1-866-266-6603\"}"
        contract.comments.must_equal "{\"main\":\" \",\"additional\":\"\"}"
      end
    end
  end
end
