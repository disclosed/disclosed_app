# Load contract data from a CSV file
# Examples:
# rake contracts:load[/path/to/csv/file.csv]
# rake contracts:load[/path/to/csv/directory]
namespace :contracts do
  desc "Update the contracts database using data in a CSV file"
  task :load, [:path] => [:environment] do |t, args|
    path = args[:path]
    if File.directory?(path)
      Dir.glob(path + "/*.csv") do |path|
        load_csv(path)
      end
    else
      load_csv(path)
    end
  end
end

def load_csv(path)
  puts "Loading CSV data from #{path}"
  loader = ContractLoader.new(path)
  contract_count = loader.contracts.length
  puts "Found #{contract_count} contracts."
  puts "Loading contracts into database."
  previous_percentage = 0
  ActiveRecord::Base.logger.silence do
    loader.upsert_into_db! do |index|
      percentage = (index.to_f / contract_count * 100).round
      if previous_percentage != percentage
        print "(#{percentage}%)"
        STDOUT.flush
        previous_percentage = percentage
      end
    end
  end
  puts "Done. Skipped #{loader.skipped_count} contracts with invalid data."
end
