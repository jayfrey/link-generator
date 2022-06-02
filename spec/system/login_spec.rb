require "rails_helper"

RSpec.describe "Login and api usage", type: :system do
  before do
    driven_by(:rack_test)
  end

  it "logs in and uses the returned token to retrieve session info" do
    visit "/auth/developer"

    fill_in "Name", with: "rspec"
    fill_in "Email", with: "rspec@example.com"
    click_button "Sign In"

    expect(current_url).to include("session_id")

    session_id = URI(current_url).query.split("=")[1]
    visit "/api/users/whoami?session_id=#{session_id}"

    expect(page).to have_text("rspec@example.com")
  end

  it "returns success: false when there is an invalid session id" do
    visit "/api/users/whoami"

    expect(page).to have_text("\"success\":false")
  end
end
