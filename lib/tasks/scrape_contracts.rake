namespace :contracts do
  desc "Scrape the contract data and load it in the DB."
  task :scrape => :environment do
    if ENV['AGENCY'].blank?
      agency = ask_for_agency
      reports = ask_for_reports(agency)
    else
      agency = Agency.find_by(abbr: ENV['AGENCY']) || (raise "Invalid code: #{ENV['AGENCY']}.")
      reports = all_reports(agency)
    end
    create_log_file(agency)
    notifier = ScraperNotifier.new
    notifier.on(:scraping_contract, -> (args) {
      print "."
      $logger.debug("Scraping URL: #{args.inspect}")
    })
    reports.each do |report|
      scraper  = scraper_for_agency(agency.abbr).new(report, notifier)
      puts_and_log "There are #{scraper.contract_urls.count} contracts in #{report.url}."
      if reports.length == 1
        range = get_range_from_user
      else
        range = 0..-1 # all reports
      end
      scrape_report(scraper, agency, range)
    end
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
  log_file.sync = true # ensure log messages are written to the file immediately
  $logger = Logger.new(log_file)
  puts "Writing to log file: #{log_file_path}"
end


def ask_for_agency
  Agency.all.each do |agency|
    if agency.has_scraper?
      puts "#{agency.abbr} - #{agency.name}"
    else
      puts "(not implemented) #{agency.abbr} - #{agency.name}"
    end
  end
  puts "Which agency would you like to scrape?"
  print "agency code > "
  code = STDIN.gets.chomp.downcase
  Agency.find_by(abbr: code) || (raise "Invalid code: #{code}.")
end

def ask_for_reports(agency)
  scraper_class  = scraper_for_agency(agency.abbr)
  reports = scraper_class.reports
  puts "Report No.\tURL"
  reports.each_with_index { |report, index| puts "#{index}\t#{report.url}" }
  puts "Which report would you like to scrape?"
  print "report number or 'all'> "

  response = STDIN.gets.chomp
  if response.downcase == 'all'
    reports
  else
    [reports[response.to_i]]
  end
end

def all_reports(agency)
  scraper_class  = scraper_for_agency(agency.abbr)
  scraper_class.reports
end

def get_range_from_user
  puts "Which contracts would you like to scrape?"
  print "Enter a range (ex. '0-20'). Default: all> "
  input = STDIN.gets.chomp
  return 0..-1 if input.blank?
  not_used, from, to = input.match(/(\d+)\-(\d+)/).to_a
  from = from.to_i
  to = to.to_i
  from..to
end

def scrape_report(scraper, agency, range)
  puts_and_log "\nScraping contracts #{range} from #{agency.abbr} report #{scraper.report.url}"
  contracts = scraper.scrape_contracts(range)
  puts_and_log "\nSaving contracts to the database"
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
rescue StandardError => e
  puts_and_log "\nError! See log for details. #{e}"
end

# Return the scraper class for the given agency code
# This relies on a naming convention for the scraper classes
# If the agency code is dfo, the class is Scrapers::Dfo::Scraper
def scraper_for_agency(agency_code)
  agency_scraper_class = agency_code.camelize
  Object.const_get("Scrapers").const_get(agency_scraper_class).const_get("Scraper")
end
