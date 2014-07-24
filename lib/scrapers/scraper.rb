module Scrapers
  class Scraper

    attr_reader :agency

    def scrape(quarter = Quarter.last)
      raise "#scrape must be implemented by child classes"
    end

    protected
    #
    #  Persisting data
    #

    # Save contract in Postgres using ActiveRecord
    # Contract data is validated by AR.
    def create_contract(hash)
      @agency.contracts.create!(hash)
    end

  end
end
