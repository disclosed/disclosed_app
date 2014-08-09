class Scrapers::Pc::PcCrawler < Scrapers::ContractCrawler

  protected
  
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
      # start_date and end_date
      start_date "css=.divRow:nth-child(5) .divRightCol" do |date|
        Contract.extract_dates(date).first
      end
      end_date "css=.divRow:nth-child(5) .divRightCol" do |date|
        Contract.extract_dates(date).try(:second)
      end
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
  def contract_urls
    quarter = @quarter
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
