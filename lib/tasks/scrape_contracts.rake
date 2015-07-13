namespace :contracts do
  desc "Scrape the contract data and load it in the DB."
  task :scrape => :environment do
    agency = ask_for_agency
    quarter = ask_for_quarter(agency)
    create_log_file(agency)
    notifier = ScraperNotifier.new
    notifier.on(:scraping_contract, -> (args) {
      print "."
      $logger.debug("Scraping URL: #{args.inspect}")
    })
    scraper  = scraper_for_agency(agency.abbr).new(quarter, notifier)
    puts_and_log "There are #{scraper.count_contracts} contracts in #{quarter}."
    scrape_quarter(scraper, agency)
  end
end

def puts_and_log(message)
  puts message
  $logger.info(message)
end

def create_log_file(agency)
  time = Time.now.strftime("%Y%m%d_%H%M")
  log_file_path = File.join(Rails.root, "log", "#{time}_#{agency.abbr}_scraper.log")
  log_file = File.open(log_file_path, "a")
  $logger = Logger.new(log_file)
end


def ask_for_agency
  Agency.all.each do |agency|
    puts "#{agency.abbr} - #{agency.name}"
  end
  puts "Which agency would you like to scrape?"
  print "agency code > "
  code = STDIN.gets.chomp.downcase
  Agency.find_by(abbr: code) || (raise "Invalid code: #{code}.")
end

def ask_for_quarter(agency)
  scraper_class  = scraper_for_agency(agency.abbr)
  quarters = scraper_class.available_quarters
  quarters.each { |quarter| puts quarter.to_s }
  puts "Which quarter would you like to scrape?"
  print "quarter code > "
  Scrapers::Quarter.parse(STDIN.gets.chomp)
end


def scrape_quarter(scraper, agency)
  puts "Scraping contracts"
  contracts = scraper.scrape_contracts
  puts "\nSaving contracts to the database"
  failed_contract_count = 0
  contracts.each do |contract|
    result = SaveContractFromScraper.call(attributes: contract, agency: agency)
    if result.success?
      print "."
    else
      failed_contract_count += 1
      print "F"
      $logger.debug result.message
    end
  end
  puts_and_log "\nRESULT: Scraped #{contracts.length}. Loaded #{contracts.length - failed_contract_count}. Failed #{failed_contract_count}."
end

# Return the scraper class for the given agency code
# This relies on a naming convention for the scraper classes
# If the agency code is dfo, the class is Scrapers::Dfo::Scraper
def scraper_for_agency(agency_code)
  agency_scraper_class = agency_code.camelize
  Object.const_get("Scrapers").const_get(agency_scraper_class).const_get("Scraper")
end
