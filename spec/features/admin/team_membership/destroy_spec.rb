require "rails_helper"

feature 'admin destroys a team membership', %{
} do
  let(:admin) { create(:admin_user) }
  let!(:team_memberships) do
    create_list(:team_membership, 2, user: admin)
  end
  let(:team_1) { team_memberships.first.team }
  let(:team_2) { team_memberships.last.team }

  scenario "signed in admin destroys a team membership" do
    sign_in_as(admin)
    visit admin_team_path(team_1)

    expect(page).to have_content(admin.name)
    click_link "Remove From Team"
    expect(page).to have_content("User Removed From Team")
    within ".team_memberships" do
      expect(page).to_not have_content(admin.name)
    end
  end

  scenario "users must belong to at least one team" do
    sign_in_as(admin)
    visit admin_team_path(team_1)
    click_link "Remove From Team"
    visit admin_team_path(team_2)
    click_link "Remove From Team"

    expect(page).to have_content(admin.name)
    expect(page).to have_content(
      "User Not Removed From Team. User Must Belong To At Least One Team"
    )
  end
end
