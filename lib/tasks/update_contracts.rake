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
  puts "Found #{loader.contracts.length} contracts."
  puts "Loading contracts into database"
  loader.upsert_into_db!
  puts "Done. Skipped #{loader.skipped_count} contracts with invalid data."
end
