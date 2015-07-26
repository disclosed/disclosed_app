class Scrapers::Dfo::Scraper < Scrapers::ContractScraper
  BASE_URL = "http://www.dfo-mpo.gc.ca/PD-CP/"

  def scrape_contract(url)
    page = Nokogiri::HTML(open(url))
    contract = {}
    contract[:vendor_name] = page.css("table.pdcp tr:nth-child(1) td").text.strip
    contract[:reference_number] = page.css("table.pdcp tr:nth-child(2) td").text.strip
    contract[:effective_date] = page.css("table.pdcp tr:nth-child(3) td").text.strip
    contract[:effective_date] = Date.parse(contract[:effective_date])
    contract[:description] = page.css("table.pdcp tr:nth-child(4) td").text.strip
    contract[:description] << "; Regional Office: "
    contract[:description] << page.css("table.pdcp tr:nth-child(8) td").text.strip
    contract[:description] << "; Contact Phone: "
    contract[:description] << page.css("table.pdcp tr:nth-child(9) td").text.strip
    contract[:raw_contract_period] = page.css("table.pdcp tr:nth-child(5) td").text.strip
    contract[:value] = page.css("table.pdcp tr:nth-child(7) td").text.strip
    contract[:value] = Monetize.parse(contract[:value]).cents / 100
    contract[:comments] = page.css("table.pdcp tr:nth-child(10) td").text.strip
    contract[:comments] << ";"
    contract[:comments] = page.css("table.pdcp tr:nth-child(11) td").text.strip
    contract[:url] = url
    contract
  end

  def contract_urls
    page = Nokogiri::HTML(open(report.url))
    page.css("table td:nth-child(2) a:nth-child(1)").map { |a_tag| "#{BASE_URL}#{a_tag['href']}" }
  end

  def self.reports
    page = Nokogiri::HTML(open("#{BASE_URL}reports-eng.asp"))
    links = page.css(".center ul li a")
    links.map { |a_tag| Scrapers::Report.new("dfo", "#{BASE_URL}#{a_tag['href']}") }
  end

end
