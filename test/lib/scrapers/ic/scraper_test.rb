require "test_helper"
describe Scrapers::Ic::Scraper do

  describe "#scrape_contract" do
    it "should parse the data from a contract page" do
      VCR.use_cassette('ic_scrape_contracts', record: :new_episodes) do
        report = mock("report")
        notifier = mock("notifier")
        scraper = Scrapers::Ic::Scraper.new(report, notifier)
        contract = scraper.scrape_contract("https://strategis.ic.gc.ca/app/scr/ic/cr/contract.html?id=134542")

        contract[:url].must_equal "https://strategis.ic.gc.ca/app/scr/ic/cr/contract.html?id=134542"
        contract[:vendor_name].must_equal "E&B DATA INC"
        contract[:reference_number].must_equal "2033722"
        contract[:raw_contract_period].must_equal "2014-09-30 - 2015-08-31"
        contract[:effective_date].must_equal Date.parse("2014-09-30")
        contract[:value].must_equal 14408
        contract[:description].must_equal "Data & Database Access"
        contract[:comments].must_equal "This contract was sole-sourced."
      end
    end
  end

  describe "#contract_urls" do
    it "should return the urls for all contract pages in the report" do
      VCR.use_cassette('ic_count_contracts', record: :new_episodes) do
        report = Scrapers::Report.new('ic', 'https://strategis.ic.gc.ca/app/scr/ic/cr/contracts.html?id=804')
        notifier = ScraperNotifier.new
        scraper = Scrapers::Ic::Scraper.new(report, notifier)
        scraper.contract_urls.length.must_equal 254
        scraper.contract_urls.first.starts_with?("https://strategis.ic.gc.ca/app/scr/ic/cr/contract.html").must_equal true
        scraper.contract_urls.first.ends_with?("?id=134542").must_equal true
      end
    end
  end

  describe ".reports" do
    it "should return all available reports for the agency" do
      VCR.use_cassette('ic_reports', record: :new_episodes) do
        reports = Scrapers::Ic::Scraper.reports
        (reports.length > 44).must_equal true
        reports.last.must_be_instance_of(Scrapers::Report)
        reports.first.agency_code.must_equal "ic"
        reports.last.url.starts_with?("https://strategis.ic.gc.ca/app/scr/ic/cr/contracts.html").must_equal true
        reports.last.url.ends_with?("?id=4").must_equal true
      end
    end
  end
end

