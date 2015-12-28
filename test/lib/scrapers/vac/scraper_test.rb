require "test_helper"
describe Scrapers::Vac::Scraper do

  describe "#scrape_contract" do
    it "should parse the data from a contract page" do
      VCR.use_cassette('vac_scrape_contracts', record: :new_episodes) do
        report = mock("report")
        notifier = mock("notifier")
        scraper = Scrapers::Vac::Scraper.new(report, notifier)
        contract = scraper.scrape_contract("http://www.veterans.gc.ca/eng/about-us/proactive-disclosure/contracts-over-10k/details/vac/47/4446")

        contract[:url].must_equal "http://www.veterans.gc.ca/eng/about-us/proactive-disclosure/contracts-over-10k/details/vac/47/4446"
        contract[:vendor_name].must_equal "COSSETTE COMMUNICATION INC."
        contract[:reference_number].must_equal "51019-15-2011-3"
        contract[:raw_contract_period].must_equal "2015-07-17 to 2015-11-11"
        contract[:effective_date].must_equal Date.parse("2011-07-17")
        contract[:value].must_equal 1_368_477
        contract[:description].must_equal "0301 ADVERTISING SERVICES"
        contract[:comments].must_equal ""
      end
    end
  end

  describe "#contract_urls" do
    it "should return the urls for all contract pages in the report" do
      VCR.use_cassette('vac_count_contracts', record: :new_episodes) do
        report = Scrapers::Report.new('vac', 'http://www.veterans.gc.ca/eng/about-us/proactive-disclosure/contracts-over-10k/report/vac/47')
        notifier = ScraperNotifier.new
        scraper = Scrapers::Vac::Scraper.new(report, notifier)
        scraper.contract_urls.length.must_equal 82
        scraper.contract_urls.first.must_equal "http://www.veterans.gc.ca/eng/about-us/proactive-disclosure/contracts-over-10k/details/vac/47/4446"
      end
    end
  end

  describe ".reports" do
    it "should return all available reports for the agency" do
      VCR.use_cassette('vac_reports', record: :new_episodes) do
        reports = Scrapers::Vac::Scraper.reports
        (reports.length > 44).must_equal true
        reports.last.must_be_instance_of(Scrapers::Report)
        reports.first.agency_code.must_equal "vac"
        reports.last.url.must_equal "http://www.veterans.gc.ca/eng/about-us/proactive-disclosure/contracts-over-10k/report/vac/47"

      end
    end
  end
end

