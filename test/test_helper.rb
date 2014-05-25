ENV["RAILS_ENV"] = "test"
require File.expand_path("../../config/environment", __FILE__)
require "rails/test_help"
require "minitest/rails"

# To add Capybara feature tests add `gem "minitest-rails-capybara"`
# to the test group in the Gemfile and uncomment the following:
require "minitest/rails/capybara"

# Uncomment for awesome colorful output
require "minitest/pride"

# Make sure the data is removed between each test
require "database_cleaner"

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
