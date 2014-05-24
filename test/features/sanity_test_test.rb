require "test_helper"

feature "SanityTest" do
  scenario "the test is sound" do
    visit root_path
    page.must_have_content "Disclosed"
  end
end
