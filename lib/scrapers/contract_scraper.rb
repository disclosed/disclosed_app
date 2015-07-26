# ContractScrapers are responsible for extracting contract information
# for a given report.
# The scraper might have to visit more than one page to get the data for
# a single contract.
require 'open-uri'
class Scrapers::ContractScraper
  attr_reader :report, :notifier

  def initialize(report, notifier)
    @report = report
    @notifier = notifier
  end

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
  def scrape_contracts(range = 0..-1)
    contract_urls[range].collect do |url|
      notifier.trigger(:scraping_contract, url)
      scrape_contract(url)
    end
  end

  # Returns the number of contracts available in the #report.
  #
  #   Scrapers::Xyz::Scraper.new(report).count_contracts
  #   #=> 128
  def count_contracts
    raise "Please implement me!"
  end

  # Scrape the main Reports page for the agency and returns all the reports
  # that the agency has contract data for.
  #
  # Returns an array of Report objects.
  def self.reports
    raise "Please implement me!"
  end
end

