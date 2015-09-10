require "rails_helper"

feature 'admin destroys a team', %{
} do
  let(:admin) { create(:admin_user) }
  let!(:team) { create(:team) }

  scenario "signed in admin edits team" do
    sign_in_as(admin)
    visit admin_team_path(team)
    click_link "Destroy Team"

    expect(page).to have_content("Team Destroyed!")
    expect(page).to_not have_content(team.name)
  end
end
