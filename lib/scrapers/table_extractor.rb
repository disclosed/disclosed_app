class Scrapers::TableExtractor
  include TextHelpers
  attr_reader :page, :result

  def initialize(url, row_mappings)
    @page = Nokogiri::HTML(open(url))
    @row_mappings = row_mappings
    @result = {}
    @result[:url] = url
    extract
  end

  def extract
    @row_mappings.each do |mapping|
      @result[mapping.field] = @page.xpath('//tr[regex(., "' + mapping.label + '")]//td[regex(., "^(?!.*' + mapping.label + ').*$")]', NokogiriXpathExtensions.new).text.strip
      @result[mapping.field] = clean_nbsp(@result[mapping.field])
      @result[mapping.field] = clean_dash(@result[mapping.field])
      @result[mapping.field] = parse_date(@result[mapping.field]) if mapping.field == :effective_date
      @result[mapping.field] = parse_value(@result[mapping.field]) if mapping.field == :value
      @result[mapping.field] = @result[mapping.field].strip if @result[mapping.field].is_a? String
    end
    @result
  end
end
