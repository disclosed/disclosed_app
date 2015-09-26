class Scrapers::Ic::Scraper < Scrapers::ContractScraper
  include Scrapers::TextHelpers

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
    contract = {}
    contract[:url] = url
    page = Nokogiri::HTML(open(url))
    mappings = [
      Scrapers::TableMapping.new(:vendor_name, "Vendor name"),
      Scrapers::TableMapping.new(:reference_number, "Reference number"),
      Scrapers::TableMapping.new(:raw_contract_period, "Contract period"),
      Scrapers::TableMapping.new(:effective_date, "Contract date"),
      Scrapers::TableMapping.new(:value, "contract value"),
      Scrapers::TableMapping.new(:description, "Description"),
      Scrapers::TableMapping.new(:comments, "Comment")
    ]
    mappings.each do |mapping|
      contract[mapping.field] = page.css(".icRow[contains('" + mapping.label + "')] .formRightCol").text.strip
      contract[mapping.field] = clean_nbsp(contract[mapping.field])
      contract[mapping.field] = clean_dash(contract[mapping.field])
      contract[mapping.field] = clean_all_spaces(contract[mapping.field])
      contract[mapping.field] = parse_date(contract[mapping.field]) if mapping.field == :effective_date
      contract[mapping.field] = parse_value(contract[mapping.field]) if mapping.field == :value
    end
    contract
  end

  # Returns the urls for the contract pages available in the #report.
  #
  #   Scrapers::Xyz::Scraper.new(report).contract_urls
  #   #=> ["http://www.pc.gc.ca/disclosure/contracts/123", ...]
  def contract_urls
    Scrapers::ContractUrlExtractor.new(report.url, "Sort by Vendor name").urls[4..-1]
  end

  # Scrape the main Reports page for the agency and returns all the report
  # that the agency has contract data for. Newest report link first.
  #
  # Returns an array of Scrapers::Report objects.
  def self.reports
    Scrapers::ReportUrlExtractor.new("https://strategis.ic.gc.ca/app/scr/ic/cr/quarters.html", "ic", "Please select a report").reports
  end
end

