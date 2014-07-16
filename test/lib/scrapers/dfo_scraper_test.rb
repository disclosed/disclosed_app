require "test_helper"

describe Scrapers::DfoScraper do
  it "should raise an error if the agency url is invalid" do
    response = Typhoeus::Response.new(code: 404, body: "Hello")
    Typhoeus.stub('http://www.example.com').and_return(response)

    scraper = Scrapers::DfoScraper.new
    scraper.stubs(:quarter_urls_since).returns(["http://www.example.com"])
    proc { scraper.scrape }.must_raise RuntimeError
  end

  it "should follow requests that have a 301 redirect" do
    response = Typhoeus::Response.new(code: 301, body: "Hello")
    Typhoeus.stub('http://www.example.com').and_return(response)
    scraper = Scrapers::DfoScraper.new
    scraper.stubs(:quarter_urls_since).returns(["http://www.example.com"])
    scraper.scrape # doesn't raise an error
  end
end
