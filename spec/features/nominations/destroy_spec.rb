require "rails_helper"

feature 'nomination destroy', %{
  As a user,
  I want to destroy a nomination,
  So I can remove accidentally created nominations

  Acceptance Criteria
  [x] Nominator should be able to delete nomination
} do
  let(:team) { create(:team) }
  let(:team_memberships) { create_list(:team_membership, 2, team: team) }
  let(:user) { team_memberships.first.user }
  let(:another_user) { team_memberships.last.user }
  let!(:nomination) do
    create(
      :nomination,
      nominee_membership: team_memberships.last,
      nominator: user
    )
  end

  scenario "nominator deletes nomination" do
    sign_in_as(user)
    click_link "Delete"

    expect(page).to have_content("Nomination Deleted!")
    within ".nominations" do
      expect(page).to_not have_content(nomination.body)
    end
  end
end
