class Scrapers::Tsb::Scraper < Scrapers::ContractScraper
  BASE_URL = "http://www.tsb.gc.ca/eng/divulgation-disclosure/contrats-contracts"

  # Scrape contract information from a page.
  #
  # url::
  #   A URL for a contract details page.
  #   Ex: "http://www.pc.gc.ca/apps/pdc/index_E.asp?oqYEAR=2013-2014&oqQUARTER=4&oqCONTRACT_ID=43649"
  #
  # Returns a Hash containing the contract data.
  #
  #   report = Scrapers::Report.new("pc", "http://www.pc.gc.ca/apps/pdc/index_E.asp?oqYEAR=2013-2014&oqQuarter=4"
  #   Scrapers::Xyz::Scraper.new(report, ScraperNotifier.new).scrape_contract("http://www.pc.gc.ca/apps/pdc/index_E.asp?oqYEAR=2013-2014&oqQUARTER=4&oqCONTRACT_ID=43649")
  #   #=>
  #     { vendor_name: "KONE INC.",
  #       reference_number: "45340584",
  #       effective_date: <#Date>,
  #       contract_period: "2014/03/31 to 2015/03/31",
  #       url: "http://www.pc.gc.ca/apps/pdc/index_E.asp?oqYEAR=2013-2014&oqQUARTER=4&oqCONTRACT_ID=43649"
  #       value: 17687,
  #       description: "665 Other equipment (specify)",
  #       comments: "Elevator Maintenance"
  #     }
  #
  def scrape_contract(url)
    mappings = [
      Scrapers::TableMapping.new(:vendor_name),
      Scrapers::TableMapping.new(:reference_number),
      Scrapers::TableMapping.new(:raw_contract_period, "contract period"),
      Scrapers::TableMapping.new(:effective_date, "contract date"),
      Scrapers::TableMapping.new(:value, "contract value"),
      Scrapers::TableMapping.new(:description),
      Scrapers::TableMapping.new(:comments)
    ]
    Scrapers::TableExtractor.new(url, mappings).result
  end

  # Returns the urls for the contract pages available in the #report.
  #
  #   Scrapers::Xyz::Scraper.new(report).contract_urls
  #   #=> ["http://www.pc.gc.ca/disclosure/contracts/123", ...]
  def contract_urls
    page = Nokogiri::HTML(open(report.url))
    results = []
    page.css("#wb-main table tr td:nth-child(2) a").each do |a_tag| 
      href = a_tag['href']
      if is_relative_link?(href)
        results << report.url.gsub('index.asp', href)
      else
        results << "http://www.tsb.gc.ca#{href}" 
      end
    end
    results
  end

  # Scrape the main Reports page for the agency and returns all the report
  # that the agency has contract data for.
  #
  # Returns an array of Scrapers::Report objects.
  def self.reports
    reports = []
    # Reports are grouped by year -> quarter
    # Need to make up the URLs manually because the yearly report pages for 2006, 
    # 2007 and 2008 are commented out in the HTML
    Date.today.year.downto(2007).each do |year|
      yearly_report = BASE_URL + "/#{year - 1}-#{year}/rapport-report.asp"
      yearly_report_page = Nokogiri::HTML(open(yearly_report))
      yearly_report_page.css("#wb-main li a").each do |a_tag|
        reports << Scrapers::Report.new("tsb", BASE_URL + "/#{year - 1}-#{year}/#{a_tag['href']}")
      end
    end
    reports
  end

  private
  def is_relative_link?(href)
    !href.start_with?('/')
  end
end

