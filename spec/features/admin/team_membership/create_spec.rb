require "rails_helper"

feature 'admin creates a team membership', %{
} do
  let!(:user) { create(:user) }
  let(:admin) { create(:admin_user) }
  let!(:team) { create(:team) }

  scenario "signed in admin creates team membership" do
    sign_in_as(admin)
    visit admin_team_path(team)
    select user.name, from: "User"
    click_button "Add To Team"

    expect(page).to have_content("Team Membership Created!")
    within ".team_memberships" do
      expect(page).to have_content(user.name)
    end
  end
end
