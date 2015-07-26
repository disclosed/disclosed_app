# Run with bin/rails g scraper agency rcmp
class ScraperGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('../templates', __FILE__)
  argument :agency, :type => :string, desc: "The abbreviated name of the agency. Ex: rcmp"

  def generate_scraper
    @agency = agency
    template "scraper.rb.erb", File.join("lib/scrapers/#{agency.downcase}/scraper.rb")
    template "scraper_test.rb.erb", File.join("test/lib/scrapers/#{agency.downcase}/scraper_test.rb")
  end

end
