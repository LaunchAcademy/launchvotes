require "rails_helper"

feature 'user show', %{
  As I user,
  I want to see my own profile,
  So I can see all the awards I've received

  Acceptance Criteria
  [x] User clicking on "Your Profile" should show a page with previous awards
  [x] Unauthorized user should be redirected to their team show page if they try to view the page
  [x] Unauthenticated user should be redirected to sign in page if they try to view the page
} do
  let(:team) { create(:enrolling_team) }
  let(:team_membership) { create(:team_membership, team: team) }
  let(:user) { team_membership.user }
  let!(:another_user) { create(:user) }
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

  context "authenticated and authorized user" do
    scenario "sees their own profile and awards from previous weeks" do
      sign_in_as(user)
      within ".top-bar" do
        click_link "Your Profile"
      end

      within ".nominations" do
        expect(page).to have_content(old_nomination.body)
        expect(page).to_not have_content(recent_nomination.body)
        expect(page).to_not have_content(nomination_without_votes.body)
      end
    end
  end

  context "authenticated non-authorized" do
    scenario "user cannot see page" do
      sign_in_as(another_user)
      visit user_path(user)

      expect(page).to have_content("You Are Not Authorized To View The Page")
    end
  end

  context "unauthenticated user" do
    it "should redirect user to sign in page" do
      visit user_path(user)
      expect(page).
        to have_content("You need to sign in or sign up before continuing")
    end
  end
end
