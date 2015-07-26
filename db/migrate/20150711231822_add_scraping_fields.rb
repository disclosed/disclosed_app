class AddScrapingFields < ActiveRecord::Migration
  def change
    add_column :contracts, :last_scraped_on, :timestamp
    add_column :contracts, :needs_scrubbing, :boolean, default: false
  end
end
