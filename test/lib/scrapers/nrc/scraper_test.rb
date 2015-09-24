require "test_helper"
describe Scrapers::Nrc::Scraper do

  describe "#scrape_contract" do
    it "should parse the data from a contract page" do
      VCR.use_cassette('nrc_scrape_contracts', record: :new_episodes) do
        report = mock("report")
        notifier = mock("notifier")
        scraper = Scrapers::Nrc::Scraper.new(report, notifier)
        contract = scraper.scrape_contract("http://www.nrc-cnrc.gc.ca/eng/transparency/disclosure/contracts/index.php?action=details&id=35804")

        contract[:url].must_equal "http://www.nrc-cnrc.gc.ca/eng/transparency/disclosure/contracts/index.php?action=details&id=35804"
        contract[:vendor_name].must_equal "F.D. MAINTENANCE 2011 INC."
        contract[:reference_number].must_equal "731313"
        contract[:raw_contract_period].must_equal "2010-04-01 to 2015-05-31"
        contract[:effective_date].must_equal Date.parse("2010-04-01")
        contract[:value].must_equal 909881
        contract[:description].must_equal "811 CONTRACTED BUILDING CLEANING"
        contract[:comments].must_equal "This contract includes one or more amendments.The Original Contract Value was: $ 151,442.93This contract was competitively sourced.This contract is a multi-year contract."
      end
    end
    it "should leave the date as nil if date is blank" do
      VCR.use_cassette('nrc_scrape_contracts_empty_date', record: :new_episodes) do
        report = mock("report")
        notifier = mock("notifier")
        scraper = Scrapers::Nrc::Scraper.new(report, notifier)
        contract = scraper.scrape_contract("http://www.nrc-cnrc.gc.ca/eng/transparency/disclosure/contracts/index.php?action=details&id=25425")

        contract[:effective_date].must_equal nil
      end
    end
  end

  describe "#contract_urls" do
    it "should return the urls for all contract pages in the report" do
      VCR.use_cassette('nrc_count_contracts', record: :new_episodes) do
        report = Scrapers::Report.new('nrc', 'http://www.nrc-cnrc.gc.ca/eng/transparency/disclosure/contracts/index.php?action=quarterly&fy=2015-2016&fq=Q1&lang=eng')
        notifier = ScraperNotifier.new
        scraper = Scrapers::Nrc::Scraper.new(report, notifier)
        scraper.contract_urls.length.must_equal 561
        scraper.contract_urls.first.must_equal "http://www.nrc-cnrc.gc.ca/eng/transparency/disclosure/contracts/index.php?action=details&id=35804"
      end
    end
  end

  describe ".reports" do
    it "should return all available reports for the agency" do
      VCR.use_cassette('nrc_reports', record: :new_episodes) do
        reports = Scrapers::Nrc::Scraper.reports
        (reports.length > 44).must_equal true
        reports.last.must_be_instance_of(Scrapers::Report)
        reports.last.url.must_equal "http://www.nrc-cnrc.gc.ca/eng/transparency/disclosure/contracts/index.php?action=quarterly&fy=2004-2005&fq=Q1&lang=eng"

      end
    end
  end
end

