require 'rails_helper'

describe User do
  it { should have_valid(:provider).when("github") }
  it { should_not have_valid(:provider).when(nil, "", "facebook") }
  it { should have_valid(:uid).when("1234") }
  it { should_not have_valid(:uid).when(nil, "") }

  describe ".from_omniauth" do
    it "should return a newly created user if they are not in the database" do
      expect { User.from_omniauth(mock_github_auth!) }.
        to change { User.count }.from(0).to(1)
      expect(User.from_omniauth(mock_github_auth!)).to be_a(User)
    end

    it "should return an existing user if they are in the database" do
      user = User.from_omniauth(mock_github_auth!)
      expect { User.from_omniauth(mock_github_auth!) }.
        not_to change { User.count }
      expect(User.from_omniauth(mock_github_auth!)).to eq(user)
    end
  end

  describe "#update_from_omniauth" do
    let(:user) do
      create(
        :user,
        email: "snorlax@pokemon.com",
        name: "Snorlax",
        image: "snorlax.jpg"
      )
    end

    it "should update the user's information" do
      user.update_from_omniauth(mock_github_auth!)
      expect(user.reload.email).to eq("jarlax@launchacademy.com")
      expect(user.reload.name).to eq("Alex Jarvis")
      expect(user.reload.image).to eq("https://avatars2.githubusercontent.com/u/174825?v=3&s=400")
    end
  end
end
