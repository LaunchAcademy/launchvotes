require "rails_helper"

feature 'admin makes a team enrolling', %{
} do
  let(:admin) { create(:admin_user) }
  let(:created_team) { build(:team) }
  let(:updated_team) { create(:team) }
  let!(:previous_enrolling_team) { create(:enrolling_team) }

  scenario "signed in admin creates team" do
    sign_in_as(admin)
    visit new_admin_team_path
    fill_in "Name", with: created_team.name
    check "Enrolling"
    click_button "Create Team"

    expect(page).to have_content(created_team.name)
    expect(page).to have_content("Currently Enrolling")
    expect(Team.enrolling.count).to eq(1)
    expect(previous_enrolling_team.reload.enrolling).to eq(false)
  end

  scenario "signed in admin updates team" do
    sign_in_as(admin)
    visit admin_team_path(updated_team)
    click_link "Edit Team"
    check "Enrolling"
    click_button "Update Team"

    expect(page).to have_content(updated_team.name)
    expect(page).to have_content("Currently Enrolling")
    expect(Team.enrolling.count).to eq(1)
    expect(previous_enrolling_team.reload.enrolling).to eq(false)
    expect(updated_team.reload.enrolling).to eq(true)
  end

  scenario "creating non-enrolling teams" do
    sign_in_as(admin)
    visit new_admin_team_path
    fill_in "Name", with: created_team.name
    click_button "Create Team"

    expect(Team.enrolling.count).to eq(1)
    expect(previous_enrolling_team.reload.enrolling).to eq(true)
  end

  scenario "updating non-enrolling teams" do
    sign_in_as(admin)
    visit edit_admin_team_path(updated_team)
    fill_in "Name", with: "New England Patriots 4 Life"
    click_button "Update Team"

    expect(Team.enrolling.count).to eq(1)
    expect(previous_enrolling_team.reload.enrolling).to eq(true)
  end
end
