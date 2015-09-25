class Scrapers::Tc::Scraper < Scrapers::ContractScraper
  BASE_URL = "http://wwwapps.tc.gc.ca/Corp-Serv-Gen/2/PDC-DPC/contract"

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
    Scrapers::TableExtractor.new(url, mappings).extract
  end

  # Returns the urls for the contract pages available in the #report.
  #
  #   Scrapers::Xyz::Scraper.new(report).contract_urls
  #   #=> ["http://www.pc.gc.ca/disclosure/contracts/123", ...]
  def contract_urls
    Scrapers::ContractUrlExtractor.new(report.url).urls
  end

  # Scrape the main Reports page for the agency and returns all the report
  # that the agency has contract data for. Newest report link first.
  #
  # Returns an array of Scrapers::Report objects.
  def self.reports
    Scrapers::ReportUrlExtractor.new("#{BASE_URL}/reports.aspx", "tc", "Please select a quarter").reports
  end
end

