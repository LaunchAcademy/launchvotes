require "rails_helper"

feature 'user sees team show page', %{
  As a user,
  I want to see my team's show page,
  So I can see who has been nominated

  Acceptance Criteria
  [x] non-admin users see all nominations for this week except my own
  [x] admin users see all nominations
  [x] unauthenticated users are redirected to the sign in page if they try to visit the page
} do
  let(:team) { create(:enrolling_team) }
  let(:team_membership) { create(:team_membership, team: team) }
  let(:another_team_membership) { create(:team_membership, team: team) }
  let(:user) { team_membership.user }
  let(:another_user) { another_team_membership.user }
  let!(:nomination) { create(:nomination, nominee_membership: team_membership) }
  let!(:another_nomination) do
    create(:nomination, nominee_membership: another_team_membership)
  end

  context "authenticated non-admin user" do
    scenario "sees team show page without his own nominations" do
      sign_in_as(user)

      within ".nominations" do
        expect(page).to have_content(another_user.name)
        expect(page).to_not have_content(user.name)
      end
    end
  end

  context "authenticated admin user" do
    let!(:admin) { create(:admin_user) }
    scenario "sees all nominations" do
      sign_in_as(admin)

      within ".nominations" do
        expect(page).to have_content(user.name)
        expect(page).to have_content(another_user.name)
      end
    end
  end

  context "unauthenticated user" do
    it "should redirect user to sign in page" do
      visit team_path(team)
      expect(page).
        to have_content("You need to sign in or sign up before continuing")
    end
  end
end
