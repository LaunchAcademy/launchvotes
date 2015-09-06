require "rails_helper"

feature 'user signs in', %{
  As a signed up user
  I want to sign in
  So that I can regain access to my account
} do
  context "new user" do
    scenario "github authenticates user" do
      mock_github_auth!

      visit root_path
      click_link "Sign In With Github"

      expect(page).to have_content("Signed in as Alex Jarvis")
      expect(page).to have_link("Sign Out", href: destroy_user_session_path)
      expect(current_path).to eq root_path
    end

    scenario "github authenticates user but returns invalid omniauth hash" do
      OmniAuth.config.mock_auth[:github] = invalid_mock_github_auth!

      visit root_path
      click_link "Sign In With Github"

      expect(page).to have_content("Invalid credentials returned from Github")
    end

    scenario "github fails to authenticate user" do
      OmniAuth.config.mock_auth[:github] = :invalid_credentials

      visit root_path
      click_link "Sign In With Github"

      expect(page).to have_content("Could not authenticate you from GitHub because \"Invalid credentials\"")
      expect(User.count).to eq(0)
    end
  end

  context "existing user" do
    let!(:user) { create(:user) }

    scenario "sign in With Launch Pass credentials" do
      sign_in_as(user)
      expect(page).to have_link("Sign Out", href: destroy_user_session_path)
    end

    scenario "sign out" do
      sign_in_as(user)
      click_link "Sign Out"
      expect(page).to have_content("Signed out successfully.")
    end

    scenario "update user attributes from Github" do
      mock_github_auth!
      OmniAuth.config.mock_auth[:github].info.name = "Bogey"

      visit root_path
      click_link "Sign In With Github"

      expect(page).to have_content("Signed in as Bogey")
    end
  end
end
