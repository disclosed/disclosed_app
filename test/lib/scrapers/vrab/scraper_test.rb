require "test_helper"
describe Scrapers::Vrab::Scraper do

  describe "#scrape_contract" do
    it "should parse the data from a contract page" do
      VCR.use_cassette('vrab_scrape_contracts', record: :new_episodes) do
        report = mock("report")
        notifier = mock("notifier")
        scraper = Scrapers::Vrab::Scraper.new(report, notifier)
        contract = scraper.scrape_contract("http://www.vrab-tacra.gc.ca/Proactive-Divulgation/2015/C-04-01-eng.cfm")

        contract[:url].must_equal "http://www.vrab-tacra.gc.ca/Proactive-Divulgation/2015/C-04-01-eng.cfm"
        contract[:vendor_name].must_equal "CAN. COMMISSIONAIRES (OTTAWA)"
        contract[:reference_number].must_equal "51235-15-0011"
        contract[:raw_contract_period].must_equal "2015-04-01 to 2016-03-31"
        contract[:effective_date].must_equal Date.parse("2015-04-01")
        contract[:value].must_equal 14102
        contract[:description].must_equal "0460  PROTECTION SERVICES"
        contract[:comments].must_equal "THIS CONTRACT IS A CALL-UP AGAINST A PUBLIC WORKS AND GOVERNMENT SERVICES CANADA PROCUREMENT TOOL"
      end
    end
  end

  describe "#contract_urls" do
    it "should return the urls for all contract pages in the report" do
      VCR.use_cassette('vrab_count_contracts', record: :new_episodes) do
        report = Scrapers::Report.new('vrab', 'http://www.vrab-tacra.gc.ca/Proactive-Divulgation/2015/1-Contracts-contrats-eng.cfm')
        notifier = ScraperNotifier.new
        scraper = Scrapers::Vrab::Scraper.new(report, notifier)
        scraper.contract_urls.length.must_equal 3
        scraper.contract_urls.first.must_equal "http://www.vrab-tacra.gc.ca/Proactive-Divulgation/2015/C-04-01-eng.cfm"
      end
    end
  end

  describe ".reports" do
    it "should return all available reports for the agency" do
      VCR.use_cassette('vrab_reports', record: :new_episodes) do
        reports = Scrapers::Vrab::Scraper.reports
        (reports.length > 15).must_equal true
        reports.last.must_be_instance_of(Scrapers::Report)
        reports.last.url.must_equal "http://www.vrab-tacra.gc.ca/Proactive-Divulgation/2009/3-Contracts-contrats-eng.cfm"
      end
    end
  end
end

