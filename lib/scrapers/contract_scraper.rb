# ContractCrawlers are responsible for extracting contract information
# for a given quarter.
# The scraper might have to visit more than one page to get the data for
# a single contract.
require_relative 'scraper_helpers'
class Scrapers::ContractScraper
  include ScraperHelpers
  attr_reader :quarter

  def initialize(quarter)
    @quarter = quarter
  end

  # Returns an Array of Hashes with contract information for each contract
  # in the quarter
  # range - Range indicating which contracts to scrape for the quarter.
  #         Ex: 0..3 Scrape the first 4 contracts.
  def contracts(range = 0..-1)
    raise "Please implement me!"
  end

  # Return an Array with the quarters for which there is contract information
  def self.available_quarters
    raise "Please implement me!"
  end

end
