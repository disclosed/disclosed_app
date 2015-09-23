require "test_helper"
describe Scrapers::Tsb::Scraper do

  describe "#scrape_contract" do
    it "should parse the data from a contract page" do
      VCR.use_cassette('tsb_scrape_contracts', record: :new_episodes) do
        report = mock("report")
        notifier = mock("notifier")
        scraper = Scrapers::Tsb::Scraper.new(report, notifier)
        contract = scraper.scrape_contract("http://www.tsb.gc.ca/eng/divulgation-disclosure/contrats-contracts/2014-2015/Q4/fournisseur-vendor-01.asp")

        contract[:url].must_equal "http://www.tsb.gc.ca/eng/divulgation-disclosure/contrats-contracts/2014-2015/Q4/fournisseur-vendor-01.asp"
        contract[:vendor_name].must_equal "Flight Safety"
        contract[:reference_number].must_equal "4M009-14-0128"
        contract[:raw_contract_period].must_equal "2015-01-19 to 2015-01-26"
        contract[:effective_date].must_equal Date.parse("2014-10-02")
        contract[:value].must_equal 19179
        contract[:description].must_equal "U010P - Certification and Accreditation - Emergent Care Training"
        contract[:comments].must_equal "Contract for flight training and certification. A Public Works and Government Services Canada standing offer was used for this contract."
      end
    end

    it "should parse data from a contract page with different markup" do
      VCR.use_cassette('tsb_scrape_contracts', record: :new_episodes) do
        report = mock("report")
        notifier = mock("notifier")
        scraper = Scrapers::Tsb::Scraper.new(report, notifier)
        contract = scraper.scrape_contract("http://www.tsb.gc.ca/eng/divulgation-disclosure/contrats-contracts/2010-2011/Q1/fournisseur-vendor_11.asp")

        contract[:url].must_equal "http://www.tsb.gc.ca/eng/divulgation-disclosure/contrats-contracts/2010-2011/Q1/fournisseur-vendor_11.asp"
        contract[:vendor_name].must_equal "Red Sash Inc."
        contract[:reference_number].must_equal "4M025-10-0014"
        contract[:raw_contract_period].must_equal "2010-06-07 to 2010-06-16"
        contract[:effective_date].must_equal Date.parse("2010-06-07")
        contract[:value].must_equal 51240
        contract[:description].must_equal "1227-Computer Equipment - Small - Desktop/Personal/ Portable/Keyboard"
        contract[:comments].must_equal ""
      end
    end
  end

  describe "#contract_urls" do
    it "should return the urls for all contract pages in the report" do
      VCR.use_cassette('tsb_count_contracts', record: :new_episodes) do
        report = Scrapers::Report.new('tsb', 'http://www.tsb.gc.ca/eng/divulgation-disclosure/contrats-contracts/2014-2015/Q4/index.asp')
        notifier = ScraperNotifier.new
        scraper = Scrapers::Tsb::Scraper.new(report, notifier)
        scraper.contract_urls.length.must_equal 12
        scraper.contract_urls.first.must_equal "http://www.tsb.gc.ca/eng/divulgation-disclosure/contrats-contracts/2014-2015/Q4/fournisseur-vendor-01.asp"
      end
    end

    it "should work when it scrapes an old report with relative links" do
      VCR.use_cassette('tsb_count_contracts_old', record: :new_episodes) do
        report = Scrapers::Report.new('tsb', 'http://www.tsb.gc.ca/eng/divulgation-disclosure/contrats-contracts/2006-2007/Q1/index.asp')
        notifier = ScraperNotifier.new
        scraper = Scrapers::Tsb::Scraper.new(report, notifier)
        scraper.contract_urls.length.must_equal 18
        scraper.contract_urls.first.must_equal 'http://www.tsb.gc.ca/eng/divulgation-disclosure/contrats-contracts/2006-2007/Q1/fournisseur-vendor_16.asp'
      end
    end
  end

  describe ".reports" do
    it "should return all available reports for the agency" do
      VCR.use_cassette('tsb_reports', record: :new_episodes) do
        reports = Scrapers::Tsb::Scraper.reports
        (reports.length > 35).must_equal true
        reports.last.must_be_instance_of(Scrapers::Report)
        reports.last.url.must_equal 'http://www.tsb.gc.ca/eng/divulgation-disclosure/contrats-contracts/2006-2007/Q1/index.asp'
      end
    end
  end
end

