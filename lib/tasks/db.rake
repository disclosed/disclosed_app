require 'pry'
namespace :db do
  namespace :data do
    desc "Create a SQL dump of the database"
    task :dump do
      db_config = Rails.configuration.database_configuration
      database = db_config[Rails.env]["database"]
      out_file = "#{Rails.root}/tmp/#{Date.today}_disclosed_backup.sql"
      success  = system "pg_dump -O -d #{database} -f #{out_file}"
      if success
        puts "Created file. #{out_file}"
      else
        puts "Could not create file."
      end
    end

    desc "Load a SQL dump from /tmp/<DATE>_disclosed_backup.sql"
    task :load do
      db_config = Rails.configuration.database_configuration
      database = db_config[Rails.env]["database"]
      dump_files = Dir.glob "#{Rails.root}/tmp/*_disclosed_backup.sql"
      if dump_files.empty?
        puts "There are no sql dumps matching the pattern /tmp/*_disclosed_backup.sql"
        exit
      end
      puts "Which dump do you want to load?"
      dump_files.each_with_index do |file, index|
        puts "[#{index}] #{file}"
      end
      print "Enter number: "
      index = STDIN.gets.chomp.to_i
      selected_dump_file = dump_files[index]
      puts "Loading tmp/#{selected_dump_file}"
      success = system "psql #{database} < #{selected_dump_file}"
      if success
        puts "Dump loaded."
      else
        puts "Could not load dump file. Try running the command manually. 'psql DATABASE_NAME < DUMPFILE.sql'"
      end
    end
  end

end
