require "test_helper"
describe Scrapers::Scc::Scraper do

  describe "#scrape_contract" do
    it "should parse the data from a contract page" do
      VCR.use_cassette('scc_scrape_contracts', record: :new_episodes) do
        report = mock("report")
        notifier = mock("notifier")
        scraper = Scrapers::Scc::Scraper.new(report, notifier)
        contract = scraper.scrape_contract("http://www.scc-csc.gc.ca/pd-dp/cd-dc-eng.aspx?id=784")

        contract[:url].must_equal "http://www.scc-csc.gc.ca/pd-dp/cd-dc-eng.aspx?id=784"
        contract[:vendor_name].must_equal "Prof. S Beaulac"
        contract[:reference_number].must_equal "1N001-1415-976"
        contract[:raw_contract_period].must_equal "2015-03-23 to 2015-04-22"
        contract[:effective_date].must_equal Date.parse("2015-03-23")
        contract[:value].must_equal 10000
        contract[:description].must_equal "0819 - Non Professional Personal Services Contracts not Elsewhere SpecifiedPreparation of a legal research document for the 7th Triennal Conference of the ACCPUF."
        contract[:comments].must_equal "This contract was sole-sourced."
      end
    end
  end

  describe "#contract_urls" do
    it "should return 0 if there are no contracts in a report" do
      VCR.use_cassette('scc_count_contracts_zero', record: :new_episodes) do
        report = Scrapers::Report.new('scc', 'http://www.scc-csc.gc.ca/pd-dp/cr-rc-eng.aspx?d1=01/04/2015&d2=30/06/2015')
        notifier = ScraperNotifier.new
        scraper = Scrapers::Scc::Scraper.new(report, notifier)
        scraper.contract_urls.length.must_equal 0
      end
    end

    it "should return the urls for all contract pages in the report" do
      VCR.use_cassette('scc_count_contracts', record: :new_episodes) do
        report = Scrapers::Report.new('scc', 'http://www.scc-csc.gc.ca/pd-dp/cr-rc-eng.aspx?d1=01/01/2015&d2=31/03/2015')
        notifier = ScraperNotifier.new
        scraper = Scrapers::Scc::Scraper.new(report, notifier)
        scraper.contract_urls.length.must_equal 28
        scraper.contract_urls.first.must_equal "http://www.scc-csc.gc.ca/pd-dp/cd-dc-eng.aspx?id=784"
      end
    end
  end

  describe ".reports" do
    it "should return all available reports for the agency" do
      VCR.use_cassette('scc_reports', record: :new_episodes) do
        reports = Scrapers::Scc::Scraper.reports
        (reports.length > 24).must_equal true
        reports.last.must_be_instance_of(Scrapers::Report)
        reports.last.url.must_equal "http://www.scc-csc.gc.ca/pd-dp/cr-rc-eng.aspx?d1=01/04/2009&d2=30/06/2009"
      end
    end
  end
end

