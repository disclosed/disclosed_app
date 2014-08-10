# ContractCrawlers are responsible for extracting contract information
# for a given quarter.
# The crawler might have to visit more than one page to get the data for
# a single contract.
class Scrapers::ContractCrawler

  def initialize(quarter = Scrapers::Quarter.latest)
    raise ArgumentError, "Invalid quarter #{quarter}" if !quarter.valid?
    @quarter = quarter
  end

  # Scrape all contracts in a given quarter
  # Returns an Array of Hashes with the contract data
  def scrape_contracts(index_range = 0..-1)
    contract_urls(@quarter)[index_range].collect do |url|
      flatten_to_json(contract_hash(url))
    end
  end

  protected
  # Scrape the contract data from a given url
  # Returns a hash with the contract information
  def contract_hash(url)
    raise "Please implement me!"
  end

  # Return an Array with the urls the parser needs to visit to scrape all
  # contracts in the quarter
  def contract_urls(quarter)
    raise "Please implement me!"
  end

  # Transform nested data into strings
  # For fields like the description field
  # Example:
  # h = {vendor: "SmartCorp Inc.", description: {main: "something cool", more: "Something interesting"}
  # flatten_to_json(h)
  # {vendor: "SmartCorp Inc.", description: "something cool; Something interesting"}
  def flatten_to_json(attrs)
    attrs.each do |k, attr|
      attrs[k] = attr.values.reject {|val| !val.present?}.join("; ") if attr.is_a? Hash
    end
  end
end
