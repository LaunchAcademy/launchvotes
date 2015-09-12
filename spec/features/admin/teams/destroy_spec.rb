require "rails_helper"

feature 'admin destroys a team', %{
} do
  let(:admin) { create(:admin_user) }
  let!(:team) { create(:team) }
  let!(:enrolling_team) { create(:enrolling_team) }

  scenario "signed in admin edits team" do
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
