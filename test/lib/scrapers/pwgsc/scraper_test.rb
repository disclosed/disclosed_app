require "test_helper"
describe Scrapers::Pwgsc::Scraper do

  describe "#scrape_contract" do
    it "should parse the data from a contract page" do
      VCR.use_cassette('pwgsc_scrape_contracts', record: :new_episodes) do
        report = mock("report")
        notifier = mock("notifier")
        scraper = Scrapers::Pwgsc::Scraper.new(report, notifier)
        contract = scraper.scrape_contract("http://www.tpsgc-pwgsc.gc.ca/cgi-bin/proactive/cl.pl?lang=eng;SCR=D;Sort=0;PF=CL201415Q2.txt;LN=554")

        contract[:url].must_equal "http://www.tpsgc-pwgsc.gc.ca/cgi-bin/proactive/cl.pl?lang=eng;SCR=D;Sort=0;PF=CL201415Q2.txt;LN=554"
        contract[:vendor_name].must_equal "THE ARCOP GROUP / GERSOVITZ MOSS"
        contract[:reference_number].must_equal "700005136"
        contract[:raw_contract_period].must_equal "2002-04-01 to 2017-03-31"
        contract[:effective_date].must_equal Date.parse("2008-04-22")
        contract[:value].must_equal 7140110
        contract[:description].must_equal "423 - Engineering Consultants - Other"
        contract[:comments].must_equal "This contract was competitively sourced. This contract includes one or more amendments. This contract is a multi-year contract. Architectural and engineering services for design of the North tower as well as construction administration. Scope of work includes design and engineering services for masonry work, scaffolding, abatement and roofing in the West Block."
      end
    end
  end

  describe "#contract_urls" do
    it "should return the urls for all contract pages in the report" do
      VCR.use_cassette('pwgsc_count_contracts', record: :new_episodes) do
        report = Scrapers::Report.new('pwgsc', 'http://www.tpsgc-pwgsc.gc.ca/cgi-bin/proactive/cl.pl?lang=eng;SCR=L;Sort=0;PF=CL201415Q2.txt')
        notifier = ScraperNotifier.new
        scraper = Scrapers::Pwgsc::Scraper.new(report, notifier)
        scraper.contract_urls.length.must_equal 1820
        scraper.contract_urls.first.must_equal "http://www.tpsgc-pwgsc.gc.ca/cgi-bin/proactive/cl.pl?lang=eng;SCR=D;Sort=0;PF=CL201415Q2.txt;LN=303"
      end
    end
  end

  describe ".reports" do
    it "should return all available reports for the agency" do
      VCR.use_cassette('pwgsc_reports', record: :new_episodes) do
        reports = Scrapers::Pwgsc::Scraper.reports
        (reports.length > 44).must_equal true
        reports.last.must_be_instance_of(Scrapers::Report)
        reports.first.agency_code.must_equal "pwgsc"
        reports.last.url.must_equal "http://www.tpsgc-pwgsc.gc.ca/cgi-bin/proactive/cl.pl?lang=eng;SCR=L;Sort=0;PF=CL200405Q1.txt"
      end
    end
  end
end

