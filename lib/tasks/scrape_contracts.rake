namespace :contracts do
  desc "Scrape the contract data for a given government agency and load it in the DB."
  task :scrape, [:agency_code] => [:environment] do |t, args|
    agency_code = args[:agency_code].try(:downcase)
    if Agency.exists?(abbr: agency_code)
      puts "Scraping contracts"
      crawler = crawler_for_agency(agency_code).new
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
      print "Invalid agency code #{agency_code}. "
      puts "Agency code must be one of: " + Agency.order("abbr asc").pluck(:abbr).join(" ")
      puts ""
      show_help
    end
  end
end

def show_help
  puts <<-eos
Usage:
rake contracts:scrape[AGENCY_CODE]
Example:
  To scrape the contracts in the most recent quarter from the Depatrment of Fisheries and Oceans
  rake contracts:scrape[dfo]
  eos
end

# Return the crawler class for the given agency code
# This relies on a naming convention for the crawler classes
# If the agency code is dfo, the class is Scrapers::Dfo::DfoCrawler
def crawler_for_agency(agency_code)
  agency_code = agency_code.camelize
  Object.const_get("Scrapers").const_get(agency_code).const_get("#{agency_code}Crawler")
end
