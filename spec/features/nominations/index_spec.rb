require "rails_helper"

feature 'user sees awards page', %{
} do
  let(:team) { create(:enrolling_team) }
  let(:team_membership) { create(:team_membership, team: team) }
  let(:user) { team_membership.user }
  let(:recent_nomination) do
    create(:nomination, nominee_membership: team_membership)
  end
  let(:old_nomination) do
    create(
      :nomination,
      nominee_membership: team_membership,
      created_at: 1.week.ago
    )
  end
  let(:nomination_without_votes) do
    create(
      :nomination,
      nominee_membership: team_membership,
      created_at: 1.week.ago
    )
  end
  let!(:vote) { create(:vote, nomination: recent_nomination) }
  let!(:old_vote) { create(:vote, nomination: old_nomination) }
  let!(:admin) { create(:admin_user) }

  context "authenticated admin user" do
    scenario "sees the team's recent awards" do
      sign_in_as(admin)
      click_link "Awards"

      within ".nominations" do
        expect(page).to have_content(recent_nomination.body)
        expect(page).to_not have_content(old_nomination.body)
        expect(page).to_not have_content(nomination_without_votes.body)
      end
    end
  end

  context "authenticated non-admin user" do
    scenario "unauthorized user cannot see page" do
      sign_in_as(user)
      visit team_nominations_path(team)

      expect(page).to have_content("You Are Not Authorized To View The Page")
    end
  end

  context "unauthenticated user" do
    it "should redirect user to sign in page" do
      visit team_nominations_path(team)
      expect(page).
        to have_content("You need to sign in or sign up before continuing")
    end
  end
end
