class Scrapers::Dfo::DfoCrawler < Scrapers::ContractCrawler

  protected
  
  def contract_hash(url)
    attrs = Wombat.crawl do
      base_url url
      path ""
      vendor_name "css=table.pdcp tr:nth-child(1) td"
      reference_number "css=table.pdcp tr:nth-child(2) td"
      effective_date "css=table.pdcp tr:nth-child(3) td" do |date|
        Date.parse(date)
      end
      description do
        main "css=table.pdcp tr:nth-child(4) td"
        regional_office "css=table.pdcp tr:nth-child(8) td" do |office|
          "Regional Office: #{office}"
        end
        contact_phone "css=table.pdcp tr:nth-child(9) td" do |phone|
          "Contact Phone: #{phone}"
        end
      end
      raw_contract_period "css=table.pdcp tr:nth-child(5) td"
      value "css=table.pdcp tr:nth-child(7) td" do |amount|
        Monetize.parse(amount).cents / 100
      end
      comments do
        main "css=table.pdcp tr:nth-child(10) td"
        additional "css=table.pdcp tr:nth-child(11) td"
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
      base_url "http://www.dfo-mpo.gc.ca/PD-CP"
      path     "/#{quarter.year}-Q#{quarter.quarter}-eng.htm"
      contract_link "xpath=//table//td[2]//a[1]/@href", :list do |all_urls|
        all_urls.map { |url| "http://www.dfo-mpo.gc.ca/PD-CP/" + url }
      end
    end

    urls.values.flatten
  end


end
