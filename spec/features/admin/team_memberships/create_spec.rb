require "rails_helper"

feature 'admin creates a team membership', %{
  As an admin,
  I want to create a team membership,
  So users can be part of multiple teams

  Acceptance Criteria
  [x] I must be able to create a membership from the admin team show page
  [x] If all users belong to the team, then no form is displayed
} do
  let(:admin) { create(:admin_user) }
  let(:team) { create(:team) }

  scenario "signed in admin creates team membership" do
    sign_in_as(admin)
    visit admin_team_path(team)
    select admin.name, from: "team_membership_user_id"
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
