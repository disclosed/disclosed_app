require "test_helper"
describe Scrapers::Tc::Scraper do

  describe "#scrape_contract" do
    it "should parse the data from a contract page" do
      VCR.use_cassette('tc_scrape_contracts', record: :new_episodes) do
        report = mock("report")
        notifier = mock("notifier")
        scraper = Scrapers::Tc::Scraper.new(report, notifier)
        contract = scraper.scrape_contract("http://wwwapps.tc.gc.ca/Corp-Serv-Gen/2/PDC-DPC/contract/detail.aspx?Contract_ID=990874&year=2014&Quarter=1")

        contract[:url].must_equal "http://wwwapps.tc.gc.ca/Corp-Serv-Gen/2/PDC-DPC/contract/detail.aspx?Contract_ID=990874&year=2014&Quarter=1"
        contract[:vendor_name].must_equal "ALPINE LINE PAINTING & TRAFFIC MARKING"
        contract[:reference_number].must_equal "T7056-14-0022"
        contract[:raw_contract_period].must_equal "2014/6/30 to 2015/3/31"
        contract[:effective_date].must_equal Date.parse("2014/6/30")
        contract[:value].must_equal 10342
        contract[:description].must_equal "Runways, landing fields and tarmac"
        contract[:comments].must_equal "This contract was sole sourced."
      end
    end
  end

  describe "#contract_urls" do
    it "should return the urls for all contract pages in the report" do
      VCR.use_cassette('tc_count_contracts', record: :new_episodes) do
        report = Scrapers::Report.new('tc', 'http://wwwapps.tc.gc.ca/Corp-Serv-Gen/2/PDC-DPC/contract/Contract_list.aspx?Quarter=1&year=2014')
        notifier = ScraperNotifier.new
        scraper = Scrapers::Tc::Scraper.new(report, notifier)
        scraper.contract_urls.length.must_equal 278
        scraper.contract_urls.first.must_equal "http://wwwapps.tc.gc.ca/Corp-Serv-Gen/2/PDC-DPC/contract/detail.aspx?Contract_ID=990874&year=2014&Quarter=1"
      end
    end
  end

  describe ".reports" do
    it "should return all available reports for the agency" do
      VCR.use_cassette('tc_reports', record: :new_episodes) do
        reports = Scrapers::Tc::Scraper.reports
        (reports.length > 24).must_equal true
        reports.last.must_be_instance_of(Scrapers::Report)
        reports.last.url.must_equal "http://wwwapps.tc.gc.ca/Corp-Serv-Gen/2/PDC-DPC/contract/Contract_list.aspx?Quarter=1&year=2009"
      end
    end
  end
end

