module Scrapers
  class DfoScraper < Scraper
    include Wombat::Crawler
    ALIAS = "dfo"
    EARLIEST_CONTRACT_QUARTER = Quarter.new(2004, 3).freeze
    # See public method #scrape in Scraper class

    def initialize
      @agency = Agency.where(abbr: ALIAS).first
    end

    # Scrape all contracts in a given quarter and  persist them 
    # in the database.
    def scrape(quarter = Quarter.latest)
      contract_urls(quarter).each do |url|
        attrs = parse_contract(url)
        create_contract(attrs)
      end
    end

    # protected
    # Extract all the contract data from a given url
    def parse_contract(url)
      attrs = Wombat.crawl do
        base_url url
        path ""
        vendor_name "css=table.pdcp tr:nth-child(1) td"
        reference_number "css=table.pdcp tr:nth-child(2) td"
        effective_date "css=table.pdcp tr:nth-child(3) td"
        description do
          main "css=table.pdcp tr:nth-child(4) td"
          regional_office "css=table.pdcp tr:nth-child(8) td"
          contact_phone "css=table.pdcp tr:nth-child(9) td"
        end
        # start_date and end_date
        start_date "css=table.pdcp tr:nth-child(5) td" do |date|
          Contract.extract_dates(date).first
        end
        end_date "css=table.pdcp tr:nth-child(5) td" do |date|
          Contract.extract_dates(date).try(:second)
        end
        value "css=table.pdcp tr:nth-child(7) td" do |amount|
          Monetize.parse(amount).cents / 100
        end
        comments do
          main "css=table.pdcp tr:nth-child(10) td"
          additional "css=table.pdcp tr:nth-child(11) td"
        end
      end
      attrs["url"] = url
      attrs = flatten_to_json(attrs)
      attrs
    end
    
    # Transform nested data to JSON strings
    def flatten_to_json(attrs)
      attrs.each do |k, attr|
        attrs[k] = attr.to_json if attr.is_a? Hash
      end
    end


    # Return all the urls the parser needs to visit to scrape all
    # the contracts in a given quarter
    def contract_urls(quarter)
      raise "Invalid quarter #{quarter}" if !quarter.valid?

      @urls = Wombat.crawl do
        base_url "http://www.dfo-mpo.gc.ca/PD-CP"
        path "/#{quarter.year}-Q#{quarter.quarter}-eng.htm"
        contract_link "xpath=//table//td[2]//a[1]/@href", :list
      end

      @urls.values.flatten
    end
  end
end
