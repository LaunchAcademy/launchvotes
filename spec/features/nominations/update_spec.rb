require "rails_helper"

feature 'nomination update', %{
} do
  let(:team) { create(:team) }
  let(:team_memberships) { create_list(:team_membership, 2, team: team) }
  let(:user) { team_memberships.first.user }
  let(:another_user) { team_memberships.last.user }
  let!(:nomination) do
    create(
      :nomination,
      nominee_membership: team_memberships.last,
      nominator: user
    )
  end

  scenario "nominator updates nomination" do
    sign_in_as(user)
    click_link "Edit"
    fill_in "nomination_body", with: "Hardest Hitting Player In The League"
    click_button "Submit"

    expect(page).to have_content("Nomination Updated!")
    within ".nominations" do
      expect(page).to have_content("Hardest Hitting Player In The League")
    end
  end

  scenario "form is submitted with invalid information" do
    sign_in_as(user)
    visit edit_nomination_path(nomination)
    fill_in "nomination_body", with: ""
    click_button "Submit"

    expect(page).to have_content("Nomination Not Updated.")
  end

  scenario "unauthorized user cannot see page" do
    sign_in_as(another_user)
    visit edit_nomination_path(nomination)

    expect(page).
      to have_content("You Are Not Authorized To View The Page")
  end

  context "unauthenticated user" do
    it "should redirect user to sign in page" do
      visit team_path(team)
      expect(page).
        to have_content("You need to sign in or sign up before continuing")
    end
  end
end
