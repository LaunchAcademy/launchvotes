require "rails_helper"

feature 'user signs in', %{
  As a user,
  I want to to authenticate,
  So I can identify myself

  Acceptance Criteria
  [x] User must be authenticated via Github OAuth
  [x] A new user must join the currently enrolling team
  [x] User must not be authenticated if Github returns invalid user credentials
  [x] User must not be authenticated if Github fails to authenticate
  [x] Existing user must be able to sign in
  [x] Existing user must be able to sign out
  [x] User credentials are updated if Github returns updated credentials
} do

  context "new user" do
    scenario "github authenticates user" do
      mock_github_auth!

      visit root_path
      click_link "Login with Github"

      expect(page).to have_content("Signed in as Alex Jarvis")
      expect(page).to have_link("Sign Out", href: destroy_user_session_path)
      expect(current_path).to eq team_path(Team.enrolling.first)
    end

    scenario "expect new user to join currently enrolling team" do
      mock_github_auth!
      enrolling_team = Team.first

      visit root_path
      click_link "Login with Github"

      expect(enrolling_team.users).to include(User.first)
    end

    scenario "github authenticates user but returns invalid omniauth hash" do
      OmniAuth.config.mock_auth[:github] = invalid_mock_github_auth!

      visit root_path
      click_link "Login with Github"

      expect(page).to have_content("Invalid credentials returned from Github")
    end

    scenario "github fails to authenticate user" do
      OmniAuth.config.mock_auth[:github] = :invalid_credentials

      visit root_path
      click_link "Login with Github"

      expect(page).to have_content("Could not authenticate you from GitHub because \"Invalid credentials\"")
      expect(User.count).to eq(0)
    end
  end

  context "existing user" do
    let!(:user) { create(:user) }

    scenario "sign in" do
      sign_in_as(user)
      expect(page).to have_link("Sign Out", href: destroy_user_session_path)
    end

    scenario "sign out" do
      sign_in_as(user)
      within ".top-bar" do
        click_link "Sign Out"
      end
      expect(page).to have_content("Signed out successfully.")
    end

    scenario "update user attributes from Github" do
      mock_github_auth!
      OmniAuth.config.mock_auth[:github].info.name = "Bogey"

      visit root_path
      click_link "Login with Github"

      expect(page).to have_content("Signed in as Bogey")
    end
  end
end
