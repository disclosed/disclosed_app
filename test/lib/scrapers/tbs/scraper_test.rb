require "test_helper"
describe Scrapers::Tbs::Scraper do

  describe "#scrape_contract" do
    it "should parse the data from a contract page" do
      VCR.use_cassette('tbs_scrape_contracts', record: :new_episodes) do
        report = mock("report")
        notifier = mock("notifier")
        scraper = Scrapers::Tbs::Scraper.new(report, notifier)
        contract = scraper.scrape_contract("http://www.tbs-sct.gc.ca/scripts/contracts-contrats/reports-rapports-eng.asp?r=c&refNum=2406215179&q=1&yr=2015&d=")

        contract[:url].must_equal "http://www.tbs-sct.gc.ca/scripts/contracts-contrats/reports-rapports-eng.asp?r=c&refNum=2406215179&q=1&yr=2015&d="
        contract[:vendor_name].must_equal "Microsoft Corporation"
        contract[:reference_number].must_equal "2406215179"
        contract[:raw_contract_period].must_equal ""
        contract[:effective_date].must_equal Date.parse("2015-02-24")
        contract[:value].must_equal 623096
        contract[:description].must_equal "1284 CLIENT SOFTWARE"
        contract[:comments].must_equal "This contract was competitively sourced.This contract includes one or more amendments.This contract is a multi-year contract."
      end
    end
  end

  describe "#contract_urls" do
    it "should return the urls for all contract pages in the report" do
      VCR.use_cassette('tbs_count_contracts', record: :new_episodes) do
        report = Scrapers::Report.new('tbs', 'http://www.tbs-sct.gc.ca/scripts/contracts-contrats/reports-rapports-eng.asp?r=l&yr=2015&q=1&d=')
        notifier = ScraperNotifier.new
        scraper = Scrapers::Tbs::Scraper.new(report, notifier)
        scraper.contract_urls.length.must_equal 47
        scraper.contract_urls.first.must_equal "http://www.tbs-sct.gc.ca/scripts/contracts-contrats/reports-rapports-eng.asp?r=c&refNum=2406240277&q=1&yr=2015&d="
      end
    end
  end

  describe ".reports" do
    it "should return all available reports for the agency" do
      VCR.use_cassette('tbs_reports', record: :new_episodes) do
        reports = Scrapers::Tbs::Scraper.reports
        (reports.length > 44).must_equal true
        reports.last.must_be_instance_of(Scrapers::Report)
        reports.first.agency_code.must_equal "tbs"
        reports.last.url.must_equal "http://www.tbs-sct.gc.ca/scripts/contracts-contrats/reports-rapports-eng.asp?r=l&yr=2004&q=1&d="

      end
    end
  end
end

