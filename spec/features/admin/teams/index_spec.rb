require "rails_helper"

feature 'admin sees list of teams', %{
  As an admin,
  I want to view all the teams,
  So I know what teams exist

  Acceptance Criteria
  [x] Admin clicking on the "Teams" link should be taken to the teams index page.
  [x] Nonadmin users should get a 404 error when attempting to view the page
  [x] Unauthenticated users should also get a 404 error when attemption to view the page
} do
  let(:user) { create(:user) }
  let(:admin) { create(:admin_user) }
  let!(:team) { create(:team) }

  scenario "signed in admin sees all teams" do
    sign_in_as(admin)
    within ".top-bar" do
      click_link "Teams"
    end

    expect(page).to have_content(team.name)
  end

  scenario "non-admin user cannot see page" do
    sign_in_as(user)
    visit admin_teams_path

    expect(page).to have_content "The page you were looking for doesn't exist."
    expect(page.status_code).to eq(404)
  end

  scenario "unauthenitcated user cannot see page" do
    visit admin_teams_path

    expect(page).to have_content "The page you were looking for doesn't exist."
    expect(page.status_code).to eq(404)
  end
end
