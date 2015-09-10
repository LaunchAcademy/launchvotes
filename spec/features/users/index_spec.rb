require "rails_helper"

feature 'user sees nominees', %{
} do
  let(:user) { create(:user) }
  let!(:nominees) { create_list(:user, 5) }

  scenario "signed in users sees all nominees except themselves" do
    sign_in_as(user)

    within ".nominee-dropdown" do
      nominees.each do |nominee|
        expect(page).to have_content(nominee.name)
      end
      expect(page).to_not have_content(user.name)
    end
  end

  scenario "unauthenticated user cannot go to the nominations page" do
    visit nominations_path

    expect(page).to have_content "You need to sign in or sign up before continuing."
  end
end
