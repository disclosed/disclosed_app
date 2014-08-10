class CrawlerGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('../templates', __FILE__)
  argument :agency, :type => :string, desc: "The abbreviated name of the agency. Ex: rcmp"

  def generate_crawler
    @agency = agency
    template "crawler.rb.erb", File.join("lib/scrapers/#{agency.downcase}/#{agency.downcase}_crawler.rb")
    template "crawler_test.rb.erb", File.join("test/lib/scrapers/#{agency.downcase}/#{agency.downcase}_crawler_test.rb")
  end

end
