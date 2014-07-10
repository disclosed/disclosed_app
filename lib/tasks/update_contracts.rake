require 'open-uri'
# Examples:
# rake contracts:load[https://raw.githubusercontent.com/disclosed/disclosed/master/data/supreme_court_of_canada_contracts.csv]
namespace :contracts do
  desc "Update the contracts database using data in a CSV file"
  task :load, [:url] => [:environment] do |t, args|
    url = args[:url]
    puts "Loading CSV data from #{url}"
    loader = ContractLoader.new(open(url).path)
    puts "Found #{loader.contracts.length} contracts."
    puts "Loading contracts into database"
    loader.upsert_into_db!
    puts "Done. Skipped #{loader.skipped_count} contracts with invalid data."
  end
end
