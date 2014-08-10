require "test_helper"
describe Scrapers::Pc::PcCrawler do

  describe "#scrape_contracts" do

    it "should parse the data from a contract page" do
      VCR.use_cassette('pc_2013_q4', record: :new_episodes) do
        y2013q4 = Scrapers::Quarter.new(2013, 4)
        scraper = Scrapers::Pc::PcCrawler.new(y2013q4)
        contracts = scraper.scrape_contracts(0..2)
        contract = contracts.first
        contract['vendor_name'].must_equal "KONE INC."
        contract['reference_number'].must_equal "45340584"
        contract['effective_date'].must_equal Date.parse("2014-03-31")
        contract['start_date'].must_equal Date.parse("2014-03-31")
        contract['end_date'].must_equal Date.parse("2015-03-31")
        contract['url'].must_equal "http://www.pc.gc.ca/apps/pdc/index_E.asp?oqYEAR=2013-2014&oqQUARTER=4&oqCONTRACT_ID=43649"
        contract['value'].must_equal 17687
        contract['description'].must_equal "665 Other equipment (specify)"
        contract['comments'].must_equal "Elevator Maintenance"
      end
    end

  end

end
