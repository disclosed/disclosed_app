module Scrapers
  class Scraper

    attr_reader :agency
    def initialize
      @agency = Agency.where(abbr: ALIAS)
    end

    def scrape(quarter = Quarter.latest)
      scrape_quarter(quarter)
    end

    protected

    # TODO: move these components in their own modules

    #
    #  Parser
    #

    # Extract data from a page using a css definition
    # Returns the data as a string.
    # parser - Nokogiri parser object
    # css_definition - a hash with css selector and optional data label
    #                  Ex: {css: "table > tr > td:first", label: "Contract date"}
    # If the css_definition contains a label, the label is prepended to the string.
    # Ex: "Contract date: 2013-01-24"
    def apply_selector(parser, css_definition)
      raise "Invalid css_definition #{css_definition}" if !css_definition.present?
      result = ""
      result << "#{css_definition[:label]}: " if css_definition.has_key? :label
      result << parser.css(css_definition[:css])
      result
    end

    # Use a selector map definition to extract all the information
    # about a contract from a page.
    # parser - Nokogiri parser from a contract page
    # map - A selector map
    def parse_from_selector_map(parser, map)
      contract_hash = {}
      map.each do |attr, css_definition|
        if css_definition.is_a? Hash
          contract_hash[attr] = apply_selector(parser, css_definition)
        elsif css_definition.is_a? Array
          contract_hash[attr] = css_definition.collect {|definition| apply_selector(parser, css_definition)}.join(";")
        end
      end
      contract_hash
    end

    #
    #  Requesting HTML
    #

    def make_request(url, &block)
      mechanize = Mechanize.new
      mechanize.get(url) { |page| yield(page) }
    end

    #
    #  Persisting data
    #

    # Save contract in Postgres using ActiveRecord
    # Contract data is validated by AR.
    def create_contract(hash)
      Contract.create(hash)
    end

  end
end