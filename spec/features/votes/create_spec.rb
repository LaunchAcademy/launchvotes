require "rails_helper"

feature 'votes create', %{
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
    click_link "Vote!"

    expect(page).to have_content("Vote Cast!")
    expect(nomination.votes.count).to eq(1)
  end
end
