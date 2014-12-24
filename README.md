[![wercker status](https://app.wercker.com/status/044339e960a4e88f16adc938cc1ba630/s "wercker status")](https://app.wercker.com/project/bykey/044339e960a4e88f16adc938cc1ba630)
[![Code Climate](https://codeclimate.com/github/disclosed/disclosed_app/badges/gpa.svg)](https://codeclimate.com/github/disclosed/disclosed_app)
[![Test Coverage](https://codeclimate.com/github/disclosed/disclosed_app/badges/coverage.svg)](https://codeclimate.com/github/disclosed/disclosed_app)

HEADS UP: This is the readme for a future release.

## About

Disclosed.ca is an open data initiative for the Canadian Government. 

This project scrapes third-party contract information from the Proactive Disclosure websites of all 64 government agencies.

The goal is to promote transparency and accountability in the Canadian Government. We make it easy for journalists and academics to access third party contract information, by aggregating the proactive disclosure data on one website.

There are 3 ways to access the data:

- Search engine: http://disclosed.ca
- CSV downloads (coming soon): http://disclosed.ca/datasets
- JSON API (coming soon): http://api.disclosed.ca


### What data is available?

We currently scrape third party contract data.

In 2004 the Government announced a new policy on the mandatory publication of contracts over $10,000. Each government agency publishes this data on a quarterly basis. Here is an example for Environment Canada: http://www.ec.gc.ca/contracts-contrats/index.cfm?lang=En&state=reports.

The format of the contract data is dictated by these [guidelines](http://www.tbs-sct.gc.ca/pd-dp/dc/index-eng.asp)

### What other data are you planning to make available?

The Proactive Disclosure Act requires every agency to publish:

- [Grants and Contribution Awards over $25000](http://w03.international.gc.ca/dg-do/index.aspx?dept=1&lang=eng&p=3&r=39)
- [Completed Access to Information Requests](http://www.international.gc.ca/department-ministere/atip-aiprp/reports-rapports/2014/05-atip_aiprp.aspx?lang=eng) titles only - not the actual report :(
- [Travel and Hospitality Expenses for Employees](http://w03.international.gc.ca/dthe-dfva/report-rapport.aspx?lang=eng&dept=1&prof_id=469&ya=2014)
- [Annual Expenditures for Travel, Hospitality Conferences](http://www.international.gc.ca/department-ministere/transparency-transparence/travel_report_fa_2012-13-rapport_voyage_ae_2012-13.aspx?lang=eng)
- [Position Reclassifications](http://www.international.gc.ca/department-ministere/transparency-transparence/reclassification.aspx?lang=eng)


### Wait, I thought the government already has an Open Data initiative!

Yes, the open data website currently publishes 209,183 data sets. But there are a few problems:

- Incomplete data sets. For example, searching for 'contracts' only yields data for 3/64 agencies [link](http://data.gc.ca/data/en/dataset?q=contracts&sort=relevance+asc&page=2).
- Too many data formats. Data is served as CSV, PDF, XML, XLS, TXT and even JPEG.
- No APIs. In the modern web ecosystem JSON APIs are a must.
- Difficult for your average citizen to view the data.

The goal of this project is to organize the data sets in a way that makes sense.

## Tech Stack

Ruby on Rails web app
Ruby on Rails API
Ruby scrapers using [Wombat](https://github.com/felipecsl/wombat)

## Scrapers

You can help out by writing a scraper for the contracts data. Here is a list of all the scrapers that need to be written: https://github.com/disclosed/disclosed_app/milestones/Kickstart%20Ruby%20scrapers

Contract data is typically structured like this.

- `Quarters Page`: list of all quarters published by an agency [example](http://www.tbs-sct.gc.ca/scripts/contracts-contrats/reports-rapports-eng.asp)
- `Contracts Page`: list of links to each contract in a quarter [example](http://www.tbs-sct.gc.ca/scripts/contracts-contrats/reports-rapports-eng.asp?r=l&yr=2013&q=4&d=)
- `Contract Detail Page`: details for a single contract [example](http://www.tbs-sct.gc.ca/scripts/contracts-contrats/reports-rapports-eng.asp?r=c&refNum=2406210451&q=4&yr=2013&d=)

### Writing a contract agency scraper

Fork this project. Take a look at some of the crawlers that were already written in `lib/scrapers/`.



Generate a new crawler for the agency.

    rails generate crawler agency rcmp
          create  lib/scrapers/rcmp/rcmp_crawler.rb
          create  test/lib/scrapers/rcmp/rcmp_crawler_test.rb


This will the crawler file you need to implement. Use Wombat to write these methods.

```ruby
class Scrapers::Rcmp::RcmpCrawler < Scrapers::ContractCrawler

  protected
  # Extract all the contract data from a contract page.
  # url - the url of the contract page
  # Returns a hash containing the contract information.
  # See test/lib/scrapers/rcmp/rcmp_crawler_test.rb for data format.
  def contract_hash(url)
    raise "Not implemented"
  end

  # Return an Array with the urls the parser needs to visit to scrape all
  # contracts in this quarter.
  def contract_urls(quarter)
    raise "Not implemented"
  end
end
```

And the test file to test your scraper:

```ruby
describe Scrapers::Rcmp::RcmpCrawler do
  describe "#scrape_contracts" do
    it "should parse the data from a contract page" do
      VCR.use_cassette('rcmp_2012_q4', record: :new_episodes) do
        quarter = Scrapers::Quarter.new(2012, 4)
        scraper = Scrapers::Rcmp::RcmpCrawler.new(quarter)
        contracts = scraper.scrape_contracts(0..2)
        contract = contracts.first
        contract['vendor_name'].must_equal 
        contract['reference_number'].must_equal 
        contract['effective_date'].must_equal Date.parse("")
        contract['start_date'].must_equal Date.parse("")
        contract['end_date'].must_equal Date.parse("")
        contract['url'].must_equal ""
        contract['value'].must_equal # Integer value (no decimals)
        contract['description'].must_equal ""
        contract['comments'].must_equal ""
      end
    end
  end
end
```

Here is an example for what the `contract_hash` method needs to return.

```ruby
contract_hash("http://www.dfo-mpo.gc.ca/PD-CP/details_e.asp?f=2013q4&r=F4748-120002")

#=>
{
 "vendor_name"=>"DOCULIBRE INC",
 "reference_number"=>"F4748-120002",
 "effective_date"=>Tue, 01 Jan 2013,  # Date object
 "description"=>
  "0473 Information Technology and Telecommunications Consultantss; Regional Office: Gulf; Contact Phone: 1-866-266-6603",
  "raw_contract_period"=>"2013-01-01 to 2013-03-31",
 "value"=>9500, # Integer
 "comments"=>"",
 "url"=>"http://www.dfo-mpo.gc.ca/PD-CP/details_e.asp?f=2013q4&r=F4748-120002"
}
```

The Wombat Wiki has a useful howto for [how to use wombat for scraping](https://github.com/felipecsl/wombat/wiki).

### Running the tests

```
bundle exec guard
```

### Running the scraper

To run your scraper for 2014, 2nd quarter:

```
rake contracts:scrape[rcmp,2014q2]
```

### Backing up entire data set

Creates a .sql file in `tmp`.

```
rake db:data:dump
```



