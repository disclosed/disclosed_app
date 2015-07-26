class Scrapers::Scc::Scraper < Scrapers::ContractScraper
  BASE_URL = "http://www.scc-csc.gc.ca"

  # Scrape contract information from a page.
  #
  # url::
  #   A URL for a contract details page.
  #   Ex: "http://www.pc.gc.ca/apps/pdc/index_E.asp?oqYEAR=2013-2014&oqQUARTER=4&oqCONTRACT_ID=43649"
  #
  # Returns a Hash containing the contract data.
  #
  #   report = Scrapers::Report.new("pc", "http://www.pc.gc.ca/apps/pdc/index_E.asp?oqYEAR=2013-2014&oqQuarter=4"
  #   Scrapers::Xyz::Scraper.new(report, ScraperNotifier.new).scrape_contract("http://www.pc.gc.ca/apps/pdc/index_E.asp?oqYEAR=2013-2014&oqQUARTER=4&oqCONTRACT_ID=43649")
  #   #=>
  #     { vendor_name: "KONE INC.",
  #       reference_number: "45340584",
  #       effective_date: <#Date>,
  #       contract_period: "2014/03/31 to 2015/03/31",
  #       url: "http://www.pc.gc.ca/apps/pdc/index_E.asp?oqYEAR=2013-2014&oqQUARTER=4&oqCONTRACT_ID=43649"
  #       value: 17687,
  #       description: "665 Other equipment (specify)",
  #       comments: "Elevator Maintenance"
  #     }
  #
  def scrape_contract(url)
    page = Nokogiri::HTML(open(url))
    contract = {}
    contract[:url] = url
    contract[:vendor_name] = page.css("#wb-main-in table tr:nth-child(1) td").text.strip
    contract[:reference_number] = page.css("#wb-main-in table tr:nth-child(2) td").text.strip
    date = page.css("#wb-main-in table tr:nth-child(3) td").text.strip
    date.gsub!(8209.chr, '-') # The site uses an unusual character to represent a dash. ASCII code 8209. Date.parse fails.
    contract[:effective_date] = Date.parse(date)
    contract[:raw_contract_period] = page.css("#wb-main-in table tr:nth-child(5) td").text.strip
    original_value = page.css("#wb-main-in table tr:nth-child(6) td").text.strip
    amended_value = page.css("#wb-main-in table tr:nth-child(7) td").text.strip
    value = amended_value.blank? ? original_value : amended_value
    contract[:value] = Monetize.parse(value).cents / 100
    contract[:description] = page.css("#wb-main-in table tr:nth-child(4) td").text.strip
    contract[:description] << "; "
    contract[:description] << page.css("#wb-main-in table tr:nth-child(8) td").text.strip
    contract[:comments] = page.css("#wb-main-in table tr:nth-child(9) td").text.strip
    contract
  end

  # Returns the urls for the contract pages available in the #report.
  #
  #   Scrapers::Xyz::Scraper.new(report).contract_urls
  #   #=> ["http://www.pc.gc.ca/disclosure/contracts/123", ...]
  def contract_urls
    page = Nokogiri::HTML(open(report.url))
    page.css("table tr a").map {|a_tag| "#{BASE_URL}#{a_tag['href']}" }
  end

  # Scrape the main Reports page for the agency and returns all the report
  # that the agency has contract data for.
  #
  # Returns an array of Scrapers::Report objects.
  def self.reports
    page = Nokogiri::HTML(open("#{BASE_URL}/pd-dp/crl-lrc-eng.aspx"))
    page.css("#wb-main-in ul li a").map do |a_tag| 
      url = "#{BASE_URL}/pd-dp/#{a_tag['href']}"
      Scrapers::Report.new("scc", url)
    end
  end
end

