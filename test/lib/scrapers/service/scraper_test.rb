require "test_helper"
describe Scrapers::Service::Scraper do

  describe "#scrape_contract" do
    it "should parse the data from a contract page" do
      VCR.use_cassette('service_scrape_contracts', record: :new_episodes) do
        report = mock("report")
        notifier = mock("notifier")
        scraper = Scrapers::Service::Scraper.new(report, notifier)
        contract = scraper.scrape_contract("http://disclosure.servicecanada.gc.ca/dp-pd/dtlcdn-eng.jsp?section=2&id=18999&employeepositionid=null&site=3&startdate=2015-01-01&enddate=2015-03-31&quarterid=45#place1")

        contract[:url].must_equal "http://disclosure.servicecanada.gc.ca/dp-pd/dtlcdn-eng.jsp?section=2&id=18999&employeepositionid=null&site=3&startdate=2015-01-01&enddate=2015-03-31&quarterid=45#place1"
        contract[:vendor_name].must_equal "RELIABLE DATA ENTRY INC."
        contract[:reference_number].must_equal "100000799/3"
        contract[:raw_contract_period].must_equal "2013-09-16 to  2014-09-30"
        contract[:effective_date].must_equal Date.parse("2012-09-27")
        contract[:value].must_equal 516813
        contract[:description].must_equal "0812 COMPUTER SERVICES"
        contract[:comments].must_equal "This contracts includes one or more amendments"
      end
    end
  end

  describe "#contract_urls" do
    it "should return the urls for all contract pages in the report" do
      VCR.use_cassette('service_count_contracts', record: :new_episodes) do
        report = Scrapers::Report.new('service', 'http://disclosure.servicecanada.gc.ca/dp-pd/smmrcdn-eng.jsp?site=3&section=2&quarterid=45&startdate=2015-01-01&enddate=2015-03-31')
        notifier = ScraperNotifier.new
        scraper = Scrapers::Service::Scraper.new(report, notifier)
        scraper.contract_urls.length.must_equal 72
        scraper.contract_urls.first.must_equal "http://disclosure.servicecanada.gc.ca/dp-pd/dtlcdn-eng.jsp?section=2&id=18999&employeepositionid=null&site=3&startdate=2015-01-01&enddate=2015-03-31&quarterid=45#place1"
      end
    end
  end

  describe ".reports" do
    it "should return all available reports for the agency" do
      VCR.use_cassette('service_reports', record: :new_episodes) do
        reports = Scrapers::Service::Scraper.reports
        (reports.length > 38).must_equal true
        reports.last.must_be_instance_of(Scrapers::Report)
        reports.first.agency_code.must_equal "service"
        reports.last.url.must_equal "http://disclosure.servicecanada.gc.ca/dp-pd/smmrcdn-eng.jsp?site=3&section=2&quarterid=22&startdate=2005-10-01&enddate=2005-12-31"

      end
    end
  end
end

