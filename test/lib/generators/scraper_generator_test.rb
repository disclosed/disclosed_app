require "test_helper"
require "generators/scraper/scraper_generator"

describe ScraperGenerator do
  tests ScraperGenerator
  destination Rails.root.join("tmp/generators")
  setup :prepare_destination

  it "generator creates the right files" do
    run_generator ["agency", "rcmp"]
    assert_file "lib/scrapers/rcmp/scraper.rb"
    assert_file "test/lib/scrapers/rcmp/scraper_test.rb"
  end
end
