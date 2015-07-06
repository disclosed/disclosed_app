require "test_helper"
describe Scrapers::Dfo::Scraper do

  describe "#contracts" do

    it "should parse the data from a contract page" do
      VCR.use_cassette('dfo_2013_q4') do
        y2013q4 = Scrapers::Quarter.new(2013, 4)
        contracts = Scrapers::Dfo::Scraper.new(y2013q4).contracts(0..1)
        contract = contracts.second
        contract['vendor_name'].must_equal "DOCULIBRE INC"
        contract['reference_number'].must_equal "F4748-120002"
        contract['effective_date'].must_equal Date.parse("2013-01-01")
        contract['raw_contract_period'].must_equal "2013-01-01 - 2013-03-31"
        contract['url'].must_equal "http://www.dfo-mpo.gc.ca/PD-CP/details_e.asp?f=2013q4&r=F4748-120002"
        contract['value'].must_equal 9500
        contract['description'].must_equal "0473 Information Technology and Telecommunications Consultantss; Regional Office: Gulf; Contact Phone: 1-866-266-6603"
        contract['comments'].must_equal ""
      end
    end

  end

end
