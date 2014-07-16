module Scrapers
  class DfoScraper

    ALIAS = "dfo"
    EARLIEST_CONTRACT_QUARTER = Quarter.new(2004, 3).freeze

    attr_reader :agency

    def initialize
      @agency = Agency.where(alias: ALIAS)
    end

    def scrape(recent = true)
      if recent
        scrape_since(Quarter.latest - 4)
      else
        scrape_since(EARLIEST_CONTRACT_QUARTER)
      end
    end

    protected
    def scrape_since(quarter)
      quarter_urls_since(quarter).each do |url|
        make_request(url) do |response|
          # parse the contents
          create_contract
        end
      end
    end

    def create_contract
      # create contract in the database
    end

    def quarter_urls_since(quarter)
      return if !quarter.valid?
      # TODO: finish this to return all urls since quarter
      return ["http://www.dfo-mpo.gc.ca/PD-CP/#{quarter.year}-Q#{quarter.quarter}-eng.htm"]
    end

    def make_request(url, &block)
      request = Typhoeus::Request.new(url, followlocation: true)
      request.on_complete do |response|
        if response.success? || response.code.to_s.first == "3"
          yield(response)
        else
          raise "There was an error accessing url: #{url}. Response code: #{response.code}"
        end
      end
      request.run
    end
  end
end
