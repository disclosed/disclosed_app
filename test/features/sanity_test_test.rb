require "test_helper"

feature "SanityTest" do
  scenario "the test is sound" do
    visit root_path
    page.find_field "query"
    page.must_have_selector :link_or_button, 'Find Contracts'
  end
end
