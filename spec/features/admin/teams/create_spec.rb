require "rails_helper"

feature 'admin creates a team', %{
  As an admin,
  I want to create a team,
  So new students can join the team

  Acceptance Criteria
  [x] Clicking on "Create Team" in the team index page takes the admin to a form where they can create a new team
  [x] Filling in invalid information does not create a team
  [x] Nonadmin users should get a 404 error when attempting to view the page
  [x] Unauthenticated users should also get a 404 error when attemption to view the page
} do
  let(:user) { create(:user) }
  let(:admin) { create(:admin_user) }
  let(:team) { build(:team) }

  scenario "signed in admin creates team" do
    sign_in_as(admin)
    visit admin_teams_path
    click_link "Create Team"
    fill_in "Name", with: team.name
    check "Enrolling"
    click_button "Create Team"

    expect(page).to have_content("Team Created!")
    expect(page).to have_content(team.name)
    expect(page).to have_content("(Enrolling)")
  end

  scenario "signed in admin fills in invalid information" do
    sign_in_as(admin)
    visit new_admin_team_path
    fill_in "Name", with: ""
    check "Enrolling"
    click_button "Create Team"

    expect(page).to have_content("Team Not Created")
    expect(page).to have_content("Name can't be blank")
    expect(page.has_checked_field? "Enrolling").to eq(true)
  end

  scenario "non-admin user cannot see page" do
    sign_in_as(user)
    visit new_admin_team_path

    expect(page).to have_content "The page you were looking for doesn't exist."
    expect(page.status_code).to eq(404)
  end

  scenario "unauthenitcated user cannot see page" do
    visit new_admin_team_path

    expect(page).to have_content "The page you were looking for doesn't exist."
    expect(page.status_code).to eq(404)
  end
end
