require "test_helper"
describe Scrapers::Nrcan::Scraper do

  describe "#scrape_contract" do
    it "should parse the data from a contract page" do
      VCR.use_cassette('nrcan_scrape_contracts', record: :new_episodes) do
        report = mock("report")
        notifier = mock("notifier")
        scraper = Scrapers::Nrcan::Scraper.new(report, notifier)
        contract = scraper.scrape_contract("http://www2.nrcan.gc.ca/dc-dpm/index.cfm?fuseaction=r.d&lang=eng&fisc=2010-2011&qrt=04&id=28229")

        contract[:url].must_equal "http://www2.nrcan.gc.ca/dc-dpm/index.cfm?fuseaction=r.d&lang=eng&fisc=2010-2011&qrt=04&id=28229"
        contract[:vendor_name].must_equal "AEL CONSULTANTS DR. S.R. CLOUDE"
        contract[:reference_number].must_equal "750066496W"
        contract[:raw_contract_period].must_equal "2011-03-31 to 2011-04-30"
        contract[:effective_date].must_equal Date.parse("2011-03-31")
        contract[:value].must_equal 18490
        contract[:description].must_equal "0431 Scientific consultants"
        contract[:comments].must_equal "Service Contract. Original contract value of $22,000.00 was modified for a revised value of $18,490.00. This contract includes one or more amendments. This contract was sole sourced."
      end
    end
  end

  describe "#contract_urls" do
    it "should return the urls for all contract pages in the report" do
      VCR.use_cassette('nrcan_count_contracts', record: :new_episodes) do
        report = Scrapers::Report.new('nrcan', 'http://www2.nrcan.gc.ca/dc-dpm/index.cfm?fuseaction=r.c&lang=eng&fisc=2010-2011&qrt=04')
        notifier = ScraperNotifier.new
        scraper = Scrapers::Nrcan::Scraper.new(report, notifier)
        scraper.contract_urls.length.must_equal 1234
        scraper.contract_urls.first.must_equal "http://www2.nrcan.gc.ca/dc-dpm/index.cfm?fuseaction=r.d&lang=eng&fisc=2010-2011&qrt=04&id=28229"
      end
    end
  end

  describe ".reports" do
    it "should return all available reports for the agency" do
      VCR.use_cassette('nrcan_reports', record: :new_episodes) do
        reports = Scrapers::Nrcan::Scraper.reports
        (reports.length > 22).must_equal true
        reports.last.must_be_instance_of(Scrapers::Report)
        reports.first.agency_code.must_equal "nrcan"
        reports.last.url.must_equal "http://www2.nrcan.gc.ca/dc-dpm/index.cfm?fuseaction=r.c&lang=eng&fisc=2009-2010&qrt=03"
      end
    end
  end
end

