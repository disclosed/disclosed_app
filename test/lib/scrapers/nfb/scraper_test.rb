require "test_helper"
describe Scrapers::Nfb::Scraper do

  describe "#scrape_contract" do
    it "should parse the data from a contract page" do
      VCR.use_cassette('nfb_scrape_contracts', record: :new_episodes) do
        report = mock("report")
        notifier = mock("notifier")
        scraper = Scrapers::Nfb::Scraper.new(report, notifier)
        contract = scraper.scrape_contract("http://onf-nfb.gc.ca/en/about-the-nfb/publications/proactive-disclosure/contract-details/?trimestre=3&anneef=2011-2012&annee=2011&refe=882830&")

        contract[:url].must_equal "http://onf-nfb.gc.ca/en/about-the-nfb/publications/proactive-disclosure/contract-details/?trimestre=3&anneef=2011-2012&annee=2011&refe=882830&"
        contract[:vendor_name].must_equal "XPAND CINEMA INC."
        contract[:reference_number].must_equal "882830"
        contract[:raw_contract_period].must_equal ""
        contract[:effective_date].must_equal Date.parse("2011-12-13")
        contract[:value].must_equal 16662
        contract[:description].must_equal "1219 - Acquisition of Other Machinery and Parts"
        contract[:comments].must_equal ""
      end
    end
  end

  describe "#contract_urls" do
    it "should return the urls for all contract pages in the report" do
      VCR.use_cassette('nfb_count_contracts', record: :new_episodes) do
        report = Scrapers::Report.new('nfb', 'http://onf-nfb.gc.ca/en/about-the-nfb/publications/proactive-disclosure/proactive-disclosure-of-contracts-over-10000/?anneef=2011-2012&annee=2011&trimestre=3')
        notifier = ScraperNotifier.new
        scraper = Scrapers::Nfb::Scraper.new(report, notifier)
        scraper.contract_urls.length.must_equal 36
        scraper.contract_urls.first.must_equal "http://onf-nfb.gc.ca/en/about-the-nfb/publications/proactive-disclosure/contract-details/?trimestre=3&anneef=2011-2012&annee=2011&refe=883071&"
      end
    end
  end

  describe ".reports" do
    it "should return all available reports for the agency" do
      VCR.use_cassette('nfb_reports', record: :new_episodes) do
        reports = Scrapers::Nfb::Scraper.reports
        (reports.length > 47).must_equal true
        reports.last.must_be_instance_of(Scrapers::Report)
        reports.first.agency_code.must_equal "nfb"
        reports.last.url.must_equal "http://onf-nfb.gc.ca/en/about-the-nfb/publications/proactive-disclosure/proactive-disclosure-of-contracts-over-10000/?anneef=2004-2005&annee=2004&trimestre=1"

      end
    end
  end
end

