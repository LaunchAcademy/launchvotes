require "rails_helper"

feature 'admin sees team show page', %{
} do
  let(:user) { create(:user) }
  let(:admin) { create(:admin_user) }
  let!(:team) { create(:team) }

  scenario "signed in admin sees team show page" do
    sign_in_as(admin)
    click_link team.name

    expect(page).to have_content(team.name)
  end

  scenario "non-admin user cannot see page" do
    sign_in_as(user)
    visit admin_teams_path(team)

    expect(page).to have_content "The page you were looking for doesn't exist."
    expect(page.status_code).to eq(404)
  end

  scenario "unauthenitcated user cannot see page" do
    visit admin_teams_path(team)

    expect(page).to have_content "The page you were looking for doesn't exist."
    expect(page.status_code).to eq(404)
  end
end
