# Report extractor for pages that have rougly this structure
# <some_element>sibling_text</some_element>
# <ul>
#   <li><a href="/reports2015q4.asp">2015 4th Quarter</a></li>
#   <li><a href="/reports2015q4.asp">2015 3rd Quarter</a></li>
#   ...
# </ul>
class Scrapers::ReportUrlExtractor
  include Scrapers::UrlHelpers
  attr_reader :reports, :page

  # sibling_text: The unique bit of text belonging to a sibling of the <ul>s that contain links
  def initialize(url, agency_code, sibling_text, sibling_tag = "p")
    @page = Nokogiri::HTML(open(url))
    links = page.xpath('//' + sibling_tag + '[contains(., "' + sibling_text + '")]//..//li//a/@href')
    @reports = links.map {|href| Scrapers::Report.new(agency_code, full_url(@page, url, href.text)) }
  end

end
