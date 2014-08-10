require "test_helper"
require "generators/crawler/crawler_generator"

describe CrawlerGenerator do
  tests CrawlerGenerator
  destination Rails.root.join("tmp/generators")
  setup :prepare_destination

  it "generator creates the right files" do
    run_generator ["agency", "rcmp"]
    assert_file "lib/scrapers/rcmp/rcmp_crawler.rb"
    assert_file "test/lib/scrapers/rcmp/rcmp_crawler_test.rb"
  end
end
