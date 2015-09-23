require "test_helper"
describe Scrapers::Wd::Scraper do

  describe "#scrape_contract" do
    it "should parse the data from a contract page" do
      VCR.use_cassette('wd_scrape_contracts', record: :new_episodes) do
        report = mock("report")
        notifier = mock("notifier")
        scraper = Scrapers::Wd::Scraper.new(report, notifier)
        contract = scraper.scrape_contract("http://www.wd.gc.ca/eng/7772.asp?id=2837&yr=2015")

        contract[:url].must_equal "http://www.wd.gc.ca/eng/7772.asp?id=2837&yr=2015"
        contract[:vendor_name].must_equal "Institute on Governance"
        contract[:reference_number].must_equal "P1600042"
        contract[:raw_contract_period].must_equal "2015-06-16 to 2017-06-22"
        contract[:effective_date].must_equal Date.parse("2015-06-17")
        contract[:value].must_equal 21000
        contract[:description].must_equal "447* - Tuition Fees and Costs of Attending Courses Including Seminars not Elsewhere Specified"
        contract[:comments].must_equal "Professional Executive Leadership Program."
      end
    end
  end

  describe "#contract_urls" do
    it "should return the urls for all contract pages in the report" do
      VCR.use_cassette('wd_count_contracts', record: :new_episodes) do
        report = Scrapers::Report.new('wd', 'http://www.wd.gc.ca/eng/7702.asp?qtr=q115')
        notifier = ScraperNotifier.new
        scraper = Scrapers::Wd::Scraper.new(report, notifier)
        scraper.contract_urls.length.must_equal 4
        scraper.contract_urls.first.must_equal "http://www.wd.gc.ca/eng/7772.asp?id=2837&yr=2015"
      end
    end
  end

  describe ".reports" do
    it "should return all available reports for the agency" do
      VCR.use_cassette('wd_reports', record: :new_episodes) do
        reports = Scrapers::Wd::Scraper.reports
        (reports.length > 44).must_equal true
        reports.last.must_be_instance_of(Scrapers::Report)
        reports.last.url.must_equal "http://www.wd.gc.ca/eng/7702.asp?qtr=q104"

      end
    end
  end
end

