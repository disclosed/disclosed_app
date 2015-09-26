require "test_helper"
describe Scrapers::Nafta::Scraper do

  describe "#scrape_contract" do
    it "should parse the data from a contract page" do
      VCR.use_cassette('nafta_scrape_contracts', record: :new_episodes) do
        report = mock("report")
        notifier = mock("notifier")
        scraper = Scrapers::Nafta::Scraper.new(report, notifier)
        contract = scraper.scrape_contract("https://www.nafta-alena.gc.ca/Home/Proactive-Disclosure-Archives/Disclosure-of-Contracts/Reports/2010-2011-1st-Qtr/Altis-Human-Resources")

        contract[:url].must_equal "https://www.nafta-alena.gc.ca/Home/Proactive-Disclosure-Archives/Disclosure-of-Contracts/Reports/2010-2011-1st-Qtr/Altis-Human-Resources"
        contract[:vendor_name].must_equal "Altis Human Resources"
        contract[:reference_number].must_equal "NAF1347"
        contract[:raw_contract_period].must_equal "2010-04-01 to 2010-06-30"
        contract[:effective_date].must_equal Date.parse("2010-03-17")
        contract[:value].must_equal 24750
        contract[:description].must_equal "Temporary help services"
        contract[:comments].must_equal ""
      end
    end
  end

  describe "#contract_urls" do
    it "should return the urls for all contract pages in the report" do
      VCR.use_cassette('nafta_count_contracts', record: :new_episodes) do
        report = Scrapers::Report.new('nafta', 'https://www.nafta-alena.gc.ca/Home/Proactive-Disclosure-Archives/Disclosure-of-Contracts/Reports/2010-2011-1st-Qtr')
        notifier = ScraperNotifier.new
        scraper = Scrapers::Nafta::Scraper.new(report, notifier)
        scraper.contract_urls.length.must_equal 2
        scraper.contract_urls.first.must_equal "https://www.nafta-alena.gc.ca/Home/ProactiveDisclosure(Archives)/DisclosureofContracts/Reports/2010-2011-1stQtr/AltisHumanResources"
      end
    end
  end

  describe ".reports" do
    it "should return all available reports for the agency" do
      VCR.use_cassette('nafta_reports', record: :new_episodes) do
        reports = Scrapers::Nafta::Scraper.reports
        (reports.length > 14).must_equal true
        reports.last.must_be_instance_of(Scrapers::Report)
        reports.first.agency_code.must_equal "nafta"
        reports.last.url.must_equal "https://www.nafta-alena.gc.ca/Home/ProactiveDisclosure(Archives)/DisclosureofContracts/Reports/2004-2005-3rdQtr"
      end
    end
  end
end

