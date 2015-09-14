require "rails_helper"

feature 'user creates a nomination', %{
} do
  let(:user) { create(:user) }
  let(:team_membership) { create(:team_membership, team: Team.enrolling.first) }
  let!(:another_user) { team_membership.user }

  scenario "user creates a nomination" do
    sign_in_as(user)

    select another_user.name, from: "nomination_nominee_membership_id"
    fill_in "nomination_body", with: "Best Flow"
    click_button "Submit"

    expect(page).to have_content("Nomination Created!")
    within ".nominations" do
      expect(page).to have_content(another_user.name)
      expect(page).to have_content("Best Flow")
    end
  end

  scenario "form filled out with invalid information" do
    sign_in_as(user)

    click_button "Submit"

    expect(page).to have_content("Nomination Not Created.")
  end
end
