require 'uri'
# Report extractor for pages that have rougly this structure
# <some_element>sibling_text</some_element>
# <ul>
#   <li><a href="/reports2015q4.asp">2015 4th Quarter</a></li>
#   <li><a href="/reports2015q4.asp">2015 3rd Quarter</a></li>
#   ...
# </ul>
class Scrapers::ReportUrlExtractor
  attr_reader :reports, :page

  # sibling_text: The unique bit of text belonging to a sibling of the <ul>s that contain links
  def initialize(url, agency_code, sibling_text, sibling_tag = "p")
    @url = url
    @uri = URI(url)
    @agency_code = agency_code
    @sibling_text = sibling_text
    @sibling_tag = sibling_tag
    @page = Nokogiri::HTML(open(url))
    @reports = extract
  end

  private
  def extract
    links = @page.xpath('//' + @sibling_tag + '[contains(., "' + @sibling_text + '")]//..//li//a/@href')
    links.map {|href| Scrapers::Report.new(@agency_code, full_url(href.text)) }
  end

  def base_tag
    @page.xpath('//base/@href').first
  end

  def base_url
    # Some sites have a <base> element that overrides the base url
    if !base_tag.nil?
      return base_tag.text
    else
      result = ""
      result << @uri.scheme
      result << "://"
      result << @uri.host
      return result
    end
  end

  def full_url(path)
    if path.starts_with?('/')
      url = "#{base_url}/#{path}"
    else
      url = "#{@url.gsub(/\/[^\/]+\Z/, '')}/#{path}"
    end
    clean_extra_slashes(url)
  end

  def clean_extra_slashes(url)
    url.gsub(/(?<!:)\/{2,}/, '/')
  end
end
