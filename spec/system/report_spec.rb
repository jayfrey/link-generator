require "rails_helper"

RSpec.describe "Report usage", type: :system do
  before do
    driven_by(:rack_test)
  end

  before(:each) do
    visit "/auth/developer"

    fill_in "Name", with: "member"
    fill_in "Email", with: "member@example.com"
    click_button "Sign In"

    @session_id = URI(current_url).query.split("=")[1]
  end

  it "doesn't allow report generation by non-admin users" do
    page.driver.post "/api/reports/?session_id=#{@session_id}"

    expect(page).to have_text("\"success\":false")
  end

  it "allows report generation by admin users" do
    visit "/api/users/whoami?session_id=#{@session_id}"
    response = JSON.parse(page.body)

    user = User.find(response.dig("data", "current_user", "id"))
    user.promote_to_admin!

    page.driver.post "/api/reports/?session_id=#{@session_id}"

    expect(page).to have_text("\"success\":true")
  end
end
