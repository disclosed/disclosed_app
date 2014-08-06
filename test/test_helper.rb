ENV["RAILS_ENV"] = "test"
require File.expand_path("../../config/environment", __FILE__)
require "rails/test_help"
require "minitest/rails"
require "support/minitest_focus"

# To add Capybara feature tests add `gem "minitest-rails-capybara"`
# to the test group in the Gemfile and uncomment the following:
require "minitest/rails/capybara"

# Uncomment for awesome colorful output
require "minitest/pride"

# VCR records web requests and plays them back in test cases
# requests are storesd in test/fixtures/vcr_casettes
require "vcr"
VCR.configure do |c|
  c.cassette_library_dir = 'test/fixtures/vcr_cassettes'
  c.hook_into :webmock
end

# Make sure the data is removed between each test
require "database_cleaner"

require "mocha/mini_test"

# Truncate tables after each test case runs
# Using :transaction here would be faster, but it doesn't work.
# TODO: Figure out why.
DatabaseCleaner.strategy = :truncation

class MiniTest::Spec
  ActiveRecord::Migration.check_pending!

  before :each do
    DatabaseCleaner.start
  end
  after :each do
    DatabaseCleaner.clean
  end
end

# Use vcr to record scraper requests
# https://github.com/vcr/vcr/wiki/Usage-with-MiniTest
# MinitestVcr::Spec.configure!
