require "rails_helper"

feature 'vote destroy', %{
} do
  let(:team) { create(:team) }
  let(:team_memberships) { create_list(:team_membership, 2, team: team) }
  let(:user) { team_memberships.first.user }
  let(:nomination) do
    create(
      :nomination,
      nominee_membership: team_memberships.last,
      nominator: user
    )
  end
  let!(:vote) { create(:vote, nomination: nomination, voter: user) }

  scenario "user retracts a vote" do
    sign_in_as(user)
    click_link "Voted!"

    expect(page).to have_content("Vote Retracted!")
    expect(nomination.votes.count).to eq(0)
  end
end
