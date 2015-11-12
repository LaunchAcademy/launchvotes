require "rails_helper"

feature 'vote destroy', %{
  As a User,
  I should be able to retract a vote,
  So I can remove votes I accidentally cast

  Acceptance Criteria
  [x] A voter should be able to click "Voted!" on a nomination which they voted on to retract a vote
  [x] Should occur without page reload
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

    within "#nomination-#{nomination.id}" do
      expect(page).to have_content("Vote")
    end
    expect(page).to have_content("Vote Retracted!")
    expect(nomination.votes.count).to eq(0)
  end

  scenario "user retracts a vote without page reload", js: true do
    sign_in_as(user)
    click_link "Voted!"

    within "#nomination-#{nomination.id}" do
      expect(page).to have_content("Vote")
    end
    expect(page).to_not have_content("Vote Retracted!")
    expect(nomination.votes.count).to eq(0)
  end
end
