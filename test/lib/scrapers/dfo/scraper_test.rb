require "test_helper"
describe Scrapers::Dfo::Scraper do

  describe "#scrape_contracts" do

    it "should parse the data from a contract page" do
      VCR.use_cassette('dfo_scrape_contracts', record: :new_episodes) do
        report = Scrapers::Report.new("dfo", "http://www.dfo-mpo.gc.ca/PD-CP/2013-Q4-eng.htm")
        notifier = mock("notifier")
        notifier.expects(:trigger).with(:scraping_contract, "http://www.dfo-mpo.gc.ca/PD-CP/details_e.asp?f=2013q4&r=F4748-120002")
        contracts = Scrapers::Dfo::Scraper.new(report, notifier).scrape_contracts(1..1)
        contract = contracts.first
        contract[:vendor_name].must_equal "DOCULIBRE INC"
        contract[:reference_number].must_equal "F4748-120002"
        contract[:effective_date].must_equal Date.parse("2013-01-01")
        contract[:raw_contract_period].must_equal "2013-01-01 - 2013-03-31"
        contract[:url].must_equal "http://www.dfo-mpo.gc.ca/PD-CP/details_e.asp?f=2013q4&r=F4748-120002"
        contract[:value].must_equal 9500
        contract[:description].must_equal "0473 Information Technology and Telecommunications Consultantss; Regional Office: Gulf; Contact Phone: 1-866-266-6603"
        contract[:comments].must_equal ""
      end
    end

  end

  describe "#contract_urls" do
    it "should return the correct contracts for 2013 q4" do
      VCR.use_cassette('dfo_count_contracts', record: :new_episodes) do
        report = Scrapers::Report.new("dfo", "http://www.dfo-mpo.gc.ca/PD-CP/2013-Q4-eng.htm")
        notifier = ScraperNotifier.new
        scraper = Scrapers::Dfo::Scraper.new(report, notifier)
        scraper.contract_urls.length.must_equal 1659
        scraper.contract_urls.first.must_equal "http://www.dfo-mpo.gc.ca/PD-CP/details_e.asp?f=2013q4&r=F2599-120291"
      end
    end
  end

  describe ".reports" do
    it "should return the correct number of reports" do
      VCR.use_cassette('dfo_reports', record: :new_episodes) do
        reports = Scrapers::Dfo::Scraper.reports
        reports.first.agency_code.must_equal "dfo"
        reports.length.must_equal 44
      end
    end

    it "should set the correct agency code and url for the first report" do
      VCR.use_cassette('dfo_reports', record: :new_episodes) do
        reports = Scrapers::Dfo::Scraper.reports
        reports.first.agency_code.must_equal "dfo"
        reports.first.url.must_equal "http://www.dfo-mpo.gc.ca/PD-CP/2015-Q4-eng.htm"
      end
    end
  end

end
