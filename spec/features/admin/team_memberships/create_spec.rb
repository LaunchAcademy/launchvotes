require "rails_helper"

feature 'admin creates a team membership', %{
} do
  let(:admin) { create(:admin_user) }
  let(:team) { create(:team) }

  scenario "signed in admin creates team membership" do
    sign_in_as(admin)
    visit admin_team_path(team)
    select admin.name, from: "User"
    click_button "Add To Team"

    expect(page).to have_content("Team Membership Created!")
    within ".team_memberships" do
      expect(page).to have_content(admin.name)
    end
  end

  context "all users belong to team" do
    let!(:team_membership) { create(:team_membership, user: admin, team: team) }
    scenario "no form is displayed" do
      sign_in_as(admin)
      visit admin_team_path(team)

      expect(page).to_not have_content("Add To Team")
    end
  end
end