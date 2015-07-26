require "test_helper"
describe Scrapers::Pc::Scraper do

  describe "#scrape_contracts" do

    it "should parse the data from the first contract in the report" do
      VCR.use_cassette('pc_scrape_contracts', record: :new_episodes) do
        report = Scrapers::Report.new("pc", "http://www.pc.gc.ca/apps/pdc/index_E.asp?oqYEAR=2013-2014&oqQUARTER=4")
        notifier = mock("notifier")
        notifier.expects(:trigger).with(:scraping_contract, "http://www.pc.gc.ca/apps/pdc/index_E.asp?oqYEAR=2013-2014&oqQUARTER=4&oqCONTRACT_ID=43649")
        contracts = Scrapers::Pc::Scraper.new(report, notifier).scrape_contracts(0..0)
        contract = contracts.first

        contract[:vendor_name].must_equal "KONE INC."
        contract[:reference_number].must_equal "45340584"
        contract[:effective_date].must_equal Date.parse("2014-03-31")
        contract[:raw_contract_period].must_equal "2014/03/31 to 2015/03/31"
        contract[:url].must_equal "http://www.pc.gc.ca/apps/pdc/index_E.asp?oqYEAR=2013-2014&oqQUARTER=4&oqCONTRACT_ID=43649"
        contract[:value].must_equal 17687
        contract[:description].must_equal "665 Other equipment (specify)"
        contract[:comments].must_equal "Elevator Maintenance"
      end
    end

  end

  describe "#contract_urls" do
    it "should return the correct number of contracts for 2013 q4" do
      VCR.use_cassette('pc_count_contracts', record: :new_episodes) do
        report = Scrapers::Report.new("pc", "http://www.pc.gc.ca/apps/pdc/index_E.asp?oqYEAR=2013-2014&oqQUARTER=4")
        notifier = ScraperNotifier.new
        report = Scrapers::Pc::Scraper.new(report, notifier)
        report.contract_urls.length.must_equal 832
        report.contract_urls.first.must_equal "http://www.pc.gc.ca/apps/pdc/index_E.asp?oqYEAR=2013-2014&oqQUARTER=4&oqCONTRACT_ID=43649"
      end
    end
  end

  describe ".reports" do
    it "should return the correct number of reports" do
      VCR.use_cassette('pc_reports', record: :new_episodes) do
        reports = Scrapers::Pc::Scraper.reports
        reports.first.agency_code.must_equal "pc"
        reports.length.must_equal 44
      end
    end

    it "should set the correct agency code and url for the first report" do
      VCR.use_cassette('pc_reports', record: :new_episodes) do
        reports = Scrapers::Pc::Scraper.reports
        reports.first.agency_code.must_equal "pc"
        reports.first.url.must_equal "http://www.pc.gc.ca/apps/pdc/index_E.asp?oqYEAR=2014-2015&oqQUARTER=4"
      end
    end
  end
end
