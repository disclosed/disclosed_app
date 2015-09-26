class Scrapers::Dfo::Scraper < Scrapers::ContractScraper
  BASE_URL = "http://www.dfo-mpo.gc.ca/PD-CP/"

  def scrape_contract(url)
    mappings = [
      Scrapers::TableMapping.new(:vendor_name),
      Scrapers::TableMapping.new(:reference_number),
      Scrapers::TableMapping.new(:raw_contract_period, "contract period"),
      Scrapers::TableMapping.new(:effective_date, "contract date"),
      Scrapers::TableMapping.new(:value, "original contract value"),
      Scrapers::TableMapping.new(:description),
      Scrapers::TableMapping.new(:comments)
    ]
    Scrapers::TableExtractor.new(url, mappings).result
  end

  def contract_urls
    Scrapers::ContractUrlExtractor.new(report.url).urls[1..-1]
  end

  def self.reports
    Scrapers::ReportUrlExtractor.new("#{BASE_URL}reports-eng.asp", "dfo", "Please select a report").reports
  end

end
