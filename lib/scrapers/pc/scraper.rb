class Scrapers::Pc::Scraper < Scrapers::ContractScraper

  BASE_URL = "http://www.pc.gc.ca/apps/pdc/"

  def self.reports
    page = Nokogiri::HTML(open("#{BASE_URL}index_e.asp"))
    report_links = page.css('.fullWidth ul li a')
    report_links.map do |a_tag|
      url = "#{BASE_URL}#{a_tag['href']}"
      Scrapers::Report.new('pc', url)
    end
  end

  def scrape_contract(url)
    page = Nokogiri::HTML(open(url))
    contract = {}
    contract[:vendor_name]         = page.css('.divRow:nth-child(1) .divRightCol').text
    contract[:reference_number]    = page.css('.divRow:nth-child(2) .divRightCol').text
    contract[:effective_date]      = page.css('.divRow:nth-child(3) .divRightCol').text
    contract[:description]         = page.css('.divRow:nth-child(4) .divRightCol').text
    contract[:raw_contract_period] = page.css('.divRow:nth-child(5) .divRightCol').text
    contract[:value]               = page.css('.divRow:nth-child(7) .divRightCol').text
    contract[:comments]            = page.css('.divRow:nth-child(8) .divRightCol').text
    contract[:url] = url
    contract = contract.merge(contract) {|key, value| value.strip } # clean whitespace on all values
    contract[:effective_date] = Date.parse(contract[:effective_date])
    contract[:value] = Monetize.parse(contract[:value]).cents / 100
    contract
  end

  # Return an Array with the urls the parser needs to visit to scrape all
  # contracts in this report
  def contract_urls
    page = Nokogiri::HTML(open(report.url))
    page.css('table td:nth-child(2) a').map { |a_tag| "#{BASE_URL}#{a_tag['href']}" }
  end

end
