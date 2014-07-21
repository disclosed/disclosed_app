module Scrapers
  class DfoScraper < Scraper

    ALIAS = "dfo"
    EARLIEST_CONTRACT_QUARTER = Quarter.new(2004, 3).freeze
    CSS_SELECTOR_MAP = {
      vendor: {css: "table.pdcp tr:nth-child(1) td"},
      reference_number: {css: "table.pdcp tr:nth-child(2) td"},
      effective_date: {css: "table.pdcp tr:nth-child(3) td"},
      description: [
        {css: "table.pdcp tr:nth-child(4) td"},
        {css: "table.pdcp tr:nth-child(8) td", label: "Regional office"},
        {css: "table.pdcp tr:nth-child(9) td", label: "Contact Phone Number"}
      ],
      contract_period:  {css: "table.pdcp tr:nth-child(5) td"},
      value:  {css: "table.pdcp tr:nth-child(7) td"},
      comments: [
        {css: "table.pdcp tr:nth-child(10) td"},
        {css: "table.pdcp tr:nth-child(11) td", label: "Additional Comments"}
      ]
    }

    # See public method #scrape in Scraper class

    protected
    # Scrape all contracts in a given quarter and 
    # persist them in the database.
    def scrape_quarter(quarter)
      contract_urls(quarter).each do |url|
        attrs = parse_contract(url)
        create_contract(attrs)
      end
    end

    # Extract all the contract data from a given url
    def parse_contract(url)
      attrs = {}
      make_request(url) do |page|
        attrs = parse_from_selector_map(page.parser, CSS_SELECTOR_MAP)
      end
      attrs
    end

    # Return all the urls the parser needs to visit to scrape all
    # the contracts in a given quarter
    def contract_urls(quarter)
      raise "Invalid quarter #{quarter}" if !quarter.valid?
      root_url = "http://www.dfo-mpo.gc.ca/PD-CP/#{quarter.year}-Q#{quarter.quarter}-eng.htm"
      url_prefix = "http://www.dfo-mpo.gc.ca/PD-CP/"
      urls = []
      make_request(root_url) do |page|
        link_tags = page.parser.css("table td:nth-child(2) > a")
        urls = link_tags.collect do |link_tag|
          if link_tag['href']
            url_prefix + link_tag['href']
          end
        end
      end
      urls.compact!
      urls
    end
  end
end
