class Scrapers::ContractUrlExtractor
  include Scrapers::UrlHelpers
  attr_reader :urls

  def initialize(report_url, th_label = "Vendor Name")
    page = Nokogiri::HTML(open(report_url))
    a_tags = page.xpath("//table[contains(., '" + th_label + "')]//a")
    @urls = a_tags.map do |a_tag|
      next if a_tag['href'].nil?
      full_url(page, report_url, a_tag['href'])
    end
    @urls.compact!
  end
end
