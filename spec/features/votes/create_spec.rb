require "rails_helper"

feature 'votes create', %{
  As a user,
  I should be able to vote on a nomination,
  So I can show my support for it

  Acceptance Criteria
  [x] User should be able to click "Vote" on a nomination from the team show page
} do
  let(:team) { create(:team) }
  let(:team_memberships) { create_list(:team_membership, 2, team: team) }
  let(:user) { team_memberships.first.user }
  let!(:nomination) do
    create(
      :nomination,
      nominee_membership: team_memberships.last,
      nominator: user
    )
  end

  scenario "user votes on a nomination" do
    sign_in_as(user)
    click_link "Vote"

    expect(page).to have_content("Vote Cast!")
    expect(nomination.votes.count).to eq(1)
  end
end
