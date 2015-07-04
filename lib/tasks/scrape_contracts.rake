# rake contracts:scrape["ec","2013q4"]
namespace :contracts do
  desc "Scrape the contract data for a given government agency and load it in the DB."
  task :scrape, [:agency_code, :quarter] => [:environment] do |t, args|
    agency_code = args[:agency_code]
    quarter_string = args[:quarter]
    if agency_code && Agency.exists?(abbr: agency_code.downcase!)
      puts "Scraping contracts"
      quarter = Scrapers::Quarter.parse(quarter_string)
      crawler = crawler_for_agency(agency_code).new(quarter)
      contracts = crawler.scrape_contracts
      puts "Found #{contracts.length} contracts."
      puts "Saving contracts in the database."
      contracts.each do |contract|
        begin
          puts "."
          Contract.create_or_update!(contract)
        rescue ActiveRecord::RecordInvalid
          puts "Invalid contract: #{contract.inspect}"
        end
      end
    else
      valid_agency_codes = Agency.order("abbr asc").pluck(:abbr)
      print "Invalid agency code #{agency_code}. "
      puts "Agency code must be one of: " + valid_agency_codes.join(" ")
      puts ""
      show_help
    end
  end
end

def show_help
  puts <<-eos
Usage:
rake contracts:scrape[AGENCY_CODE,QUARTER]
Example:
  To scrape the contracts in the most recent quarter from the Depatrment of Fisheries and Oceans
  rake contracts:scrape[dfo,2013q2]
  eos
end

# Return the crawler class for the given agency code
# This relies on a naming convention for the crawler classes
# If the agency code is dfo, the class is Scrapers::Dfo::DfoCrawler
def crawler_for_agency(agency_code)
  agency_scraper_class = agency_code.camelize
  Object.const_get("Scrapers").const_get(agency_scraper_class).const_get("#{agency_scraper_class}Crawler")
end
