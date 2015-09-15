require "rails_helper"

feature 'admin destroys a team', %{
  As an admin,
  I want delete a team,
  So I can get rid of any teams accidentally created

  Acceptance Criteria
  [x] I must be able to click "Destroy Team" from the team show page to delete a team
  [x] I should not be able to destroy the currently enrolling team
} do
  let(:admin) { create(:admin_user) }
  let!(:team) { create(:team) }
  let!(:enrolling_team) { create(:enrolling_team) }

  scenario "signed in admin deletes team" do
    sign_in_as(admin)
    visit admin_team_path(team)
    click_link "Destroy Team"

    expect(page).to have_content("Team Destroyed!")
    expect(page).to_not have_content(team.name)
    expect { team.reload }.to raise_error ActiveRecord::RecordNotFound
  end

  scenario "admin cannot destroy currently enrolling team" do
    sign_in_as(admin)
    visit admin_team_path(enrolling_team)

    expect(page).to have_content("Currently Enrolling")
    expect(page).to_not have_link("Destroy Team")
  end
end
