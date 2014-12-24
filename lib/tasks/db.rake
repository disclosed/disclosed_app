namespace :db do
  namespace :data do
    desc "Create a SQL dump of the database"
    task :dump do
      config   = Rails.configuration.database_configuration
      database = config[Rails.env]["database"]
      out_file = "#{Rails.root}/tmp/#{Date.today}_disclosed_backup.sql"
      success  = system "pg_dump -O -d #{database} -f #{out_file}"
      if success
        puts "Created file. #{out_file}"
      else
        puts "Could not create file."
      end
    end
  end
end
