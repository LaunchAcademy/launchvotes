require "rails_helper"

feature 'admin updates a team', %{
  As an admin,
  I want to update a team
  So I can fix erroneous information

  Acceptance Criteria
  [x] Clicking on "Edit Team" on the team show page should take the admin to a form that updates the team
  [x] Filling in invalid information does not update the team
  [x] Enrolling teams cannot be made unenrolling
  [x] Nonadmin users should get a 404 error when attempting to view the page
  [x] Unauthenticated users should also get a 404 error when attemption to view the page
} do
  let(:user) { create(:user) }
  let(:admin) { create(:admin_user) }
  let!(:team) { create(:team) }
  let!(:enrolling_team) { create(:enrolling_team) }

  scenario "signed in admin updates team" do
    sign_in_as(admin)
    visit admin_team_path(enrolling_team)
    click_link "Edit Team"
    fill_in "team_name", with: "Admin Overlords"
    click_button "Update Team"

    expect(page).to have_content("Team Updated!")
    expect(page).to have_content("Admin Overlords")
  end

  scenario "signed in admin fills in invalid information" do
    sign_in_as(admin)
    visit admin_team_path(team)
    click_link "Edit Team"
    fill_in "team_name", with: ""
    check "Enrolling"
    click_button "Update Team"

    expect(page).to have_content("Team Not Updated")
    expect(page).to have_content("Name can't be blank")
  end

  scenario "admin cannot make a currently enrolling team unenrolling" do
    sign_in_as(admin)
    visit admin_team_path(enrolling_team)
    click_link "Edit Team"

    expect(page).to_not have_field("Enrolling")
  end

  scenario "non-admin user cannot see page" do
    sign_in_as(user)
    visit edit_admin_team_path(team)

    expect(page).to have_content "The page you were looking for doesn't exist."
    expect(page.status_code).to eq(404)
  end

  scenario "unauthenitcated user cannot see page" do
    visit edit_admin_team_path(team)

    expect(page).to have_content "The page you were looking for doesn't exist."
    expect(page.status_code).to eq(404)
  end
end
