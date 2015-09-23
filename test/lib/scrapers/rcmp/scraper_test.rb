require "test_helper"
describe Scrapers::Rcmp::Scraper do

  describe "#scrape_contract" do
    it "should parse the data from a contract page" do
      VCR.use_cassette('rcmp_scrape_contracts', record: :new_episodes) do
        report = mock("report")
        notifier = mock("notifier")
        scraper = Scrapers::Rcmp::Scraper.new(report, notifier)
        contract = scraper.scrape_contract("http://www.rcmp-grc.gc.ca/en/apps/contra/index.php?r-id=41740")

        contract[:url].must_equal "http://www.rcmp-grc.gc.ca/en/apps/contra/index.php?r-id=41740"
        contract[:vendor_name].must_equal "THE CITY OF LEDUC"
        contract[:reference_number].must_equal "4500000271"
        contract[:raw_contract_period].must_equal "2005-04-01 to 2015-06-30"
        contract[:effective_date].must_equal Date.parse("2005-04-01")
        contract[:value].must_equal 1646280
        contract[:description].must_equal "514 - Rental of other buildings"
        contract[:comments].must_equal "RCMP invoicing planThis contract was competitively sourced.This contract includes one or more amendments."
      end
    end
  end

  describe "#contract_urls" do
    it "should return the total count of contracts in the report" do
      VCR.use_cassette('rcmp_count_contracts', record: :new_episodes) do
        report = Scrapers::Report.new('rcmp', 'http://www.rcmp-grc.gc.ca/en/apps/contra/index.php?y-a=2014&q-t=4')
        notifier = ScraperNotifier.new
        scraper = Scrapers::Rcmp::Scraper.new(report, notifier)
        scraper.contract_urls.length.must_equal 1058
        scraper.contract_urls.first.must_equal "http://www.rcmp.gc.ca/en/apps/contra/?r-id=41740"
      end
    end
  end

  describe ".reports" do
    it "should return all available reports for the agency" do
      VCR.use_cassette('rcmp_reports', record: :new_episodes) do
        reports = Scrapers::Rcmp::Scraper.reports
        reports.first.must_be_instance_of(Scrapers::Report)
      end
    end

    it "should set the correct agency code and url for the first report" do
      VCR.use_cassette('rcmp_reports', record: :new_episodes) do
        reports = Scrapers::Rcmp::Scraper.reports
        reports.first.agency_code.must_equal 'rcmp'
        reports.first.url.must_equal "http://www.rcmp.gc.ca/en/apps/contra/?y-a=2014&q-t=4"
      end
    end
  end
end

