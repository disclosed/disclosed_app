class Scrapers::Pc::Scraper < Scrapers::ContractScraper

  def contracts(range = 0..-1)
    contract_urls(quarter)[range].collect do |url|
      flatten_to_json(contract_hash(url))
    end
  end

  private
  def contract_hash(url)
    attrs = Wombat.crawl do
      base_url url
      path ""
      vendor_name "css=.divRow:nth-child(1) .divRightCol"
      reference_number "css=.divRow:nth-child(2) .divRightCol"
      effective_date "css=.divRow:nth-child(3) .divRightCol" do |date|
        Date.parse(date)
      end
      description do
        main "css=.divRow:nth-child(4) .divRightCol"
      end
      raw_contract_period "css=.divRow:nth-child(5) .divRightCol"
      value "css=.divRow:nth-child(7) .divRightCol" do |amount|
        Monetize.parse(amount).cents / 100
      end
      comments do
        main "css=.divRow:nth-child(8) .divRightCol"
      end
    end
    attrs["url"] = url
    attrs
  end

  # Figure out the urls that contain the data for each contract
  # Return an Array with the urls the parser needs to visit to scrape all
  # contracts in this quarter
  def contract_urls(quarter)
    urls = Wombat.crawl do
      base_url "http://www.pc.gc.ca/apps/pdc/index_e.asp"
      path     "?oqYEAR=#{quarter.year}-#{quarter.year + 1}&oqQUARTER=#{quarter.quarter}"
      contract_link "xpath=//table//td[2]//a[1]/@href", :list do |all_urls|
        all_urls.map { |url| "http://www.pc.gc.ca/apps/pdc/" + url }
      end
    end
    urls.values.flatten
  end


end
