class Scrapers::Rcmp::Scraper < Scrapers::ContractScraper
  BASE_URL = "http://www.rcmp.gc.ca"
  # Scrape contracts for the given #report
  #
  # While scraping, use the notifier to let the scraper runner know when
  # you are scraping a new contract page.
  #    notifier.send(:scraping_contract, "http://www.pc.gc.ca/apps/pdc/index_E.asp?oqYEAR=2013-2014&oqQUARTER=4&oqCONTRACT_ID=43649")
  #
  # range::
  #   A Range indicating which contracts to scrape from the #report.
  #
  # Returns an Array of Hashes containing the contract data.
  #
  #   report = Scrapers::Report.new("pc", "http://www.pc.gc.ca/apps/pdc/index_E.asp?oqYEAR=2013-2014&oqQuarter=4"
  #   Scrapers::Xyz::Scraper.new(q4, ScraperNotifier.new).contracts(0..1)
  #   #=> [
  #     { vendor_name: "KONE INC.",
  #       reference_number: "45340584",
  #       effective_date: <#Date>,
  #       contract_period: "2014/03/31 to 2015/03/31",
  #       url: "http://www.pc.gc.ca/apps/pdc/index_E.asp?oqYEAR=2013-2014&oqQUARTER=4&oqCONTRACT_ID=43649"
  #       value: 17687,
  #       description: "665 Other equipment (specify)",
  #       comments: "Elevator Maintenance"
  #     },
  #     {...}
  #   ]
  #
  def scrape_contract(url)
    mappings = [
      Scrapers::TableMapping.new(:vendor_name),
      Scrapers::TableMapping.new(:reference_number),
      Scrapers::TableMapping.new(:raw_contract_period, "contract period"),
      Scrapers::TableMapping.new(:effective_date, "contract date"),
      Scrapers::TableMapping.new(:description),
      Scrapers::TableMapping.new(:comments)
    ]
    extractor = Scrapers::TableExtractor.new(url, mappings)
    contract = extractor.result

    contract[:value] = extractor.page.css("table tr:nth-child(7) td").text.strip
    if match = contract[:value].match(/Amended contract value\: \$(.*)Original contract value\: \$(.*)/)
      contract[:value] = Monetize.parse(match[1]).cents / 100
    else
      raise "Unexpected contract value data: #{contract[:value]}. URL: #{url}"
    end

    contract
  end

  # Returns an Array of contract urls for the given report
  #
  #   Scrapers::Xyz::Scraper.new(report).contract_urls
  #   #=> 128
  def contract_urls
    page = Nokogiri::HTML(open(report.url))
    page.css("main table td a").map {|a_tag| "#{BASE_URL}#{a_tag['href']}"} # they are missing tr elements
  end

  # Scrape the main Reports page for the agency and returns all the report
  # that the agency has contract data for.
  #
  # Returns an array of Scrapers::Report objects.
  def self.reports
    page = Nokogiri::HTML(open("#{BASE_URL}/en/apps/contra/index.php?lst=1"))
    page.css("main ul li a").map do |a_tag|
      Scrapers::Report.new("rcmp", "#{BASE_URL}#{a_tag['href']}")
    end
  end
end

