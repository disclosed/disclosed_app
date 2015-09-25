require "test_helper"
describe Scrapers::Stat::Scraper do

  describe "#scrape_contract" do
    it "should parse the data from a contract page" do
      VCR.use_cassette('stat_scrape_contracts', record: :new_episodes) do
        report = mock("report")
        notifier = mock("notifier")
        scraper = Scrapers::Stat::Scraper.new(report, notifier)
        contract = scraper.scrape_contract("http://www.statcan.gc.ca/eng/about/contract/2006/72800-06-0039")

        contract[:url].must_equal "http://www.statcan.gc.ca/eng/about/contract/2006/72800-06-0039"
        contract[:vendor_name].must_equal "Programmer's Paradise"
        contract[:reference_number].must_equal "72800-06-0039"
        contract[:raw_contract_period].must_equal "July 15, 2006 to July 14, 2007"
        contract[:effective_date].must_equal Date.parse("July 4, 2006")
        contract[:value].must_equal 10375
        contract[:description].must_equal "1172 Office and stationers supplies"
        contract[:comments].must_equal "Software including Maintenance - Stylus Studio (Qty 7)"
      end
    end
  end

  describe "#contract_urls" do
    it "should return the urls for all contract pages in the report" do
      VCR.use_cassette('stat_count_contracts', record: :new_episodes) do
        report = Scrapers::Report.new('stat', 'http://www.statcan.gc.ca/eng/about/contract/200602')
        notifier = ScraperNotifier.new
        scraper = Scrapers::Stat::Scraper.new(report, notifier)
        scraper.contract_urls.length.must_equal 96
        scraper.contract_urls.first.must_equal "http://www.statcan.gc.ca/eng/about/contract/2006/72800-06-0039"
      end
    end
  end

  describe ".reports" do
    it "should return all available reports for the agency" do
      VCR.use_cassette('stat_reports', record: :new_episodes) do
        reports = Scrapers::Stat::Scraper.reports
        (reports.length > 44).must_equal true
        reports.last.must_be_instance_of(Scrapers::Report)
        reports.first.agency_code.must_equal "stat"
        reports.last.url.must_equal "http://www.statcan.gc.ca/eng/about/contract/200401"

      end
    end
  end
end

