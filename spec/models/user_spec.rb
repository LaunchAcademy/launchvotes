require 'rails_helper'

describe User do
  it { should have_many(:team_memberships).dependent(:destroy) }
  it { should have_many(:teams).through(:team_memberships) }
  it { should have_many(:votes).with_foreign_key("voter_id").dependent(:destroy) }

  it { should have_valid(:provider).when("github") }
  it { should_not have_valid(:provider).when(nil, "", "facebook") }

  it { should have_valid(:uid).when("1234") }
  it { should_not have_valid(:uid).when(nil, "") }

  describe ".nonmembers" do
    let!(:user) { create(:user) }
    let!(:team_membership) { create(:team_membership) }
    let(:team_member) { team_membership.user }
    let(:team) { team_membership.team }
    it "should return users not part of the team" do
      expect(User.nonmembers(team)).to include(user)
      expect(User.nonmembers(team)).to_not include(team_member)
    end
  end

  describe ".from_omniauth" do
    context "with a valid omniauth hash" do
      it "should return a newly created user if new user" do
        expect { User.from_omniauth(mock_github_auth!) }.
          to change { User.count }.from(0).to(1)
        expect(User.from_omniauth(mock_github_auth!)).to be_a(User)
      end

      it "should return an existing user if user has previously authenticated" do
        user = User.from_omniauth(mock_github_auth!)
        expect { User.from_omniauth(mock_github_auth!) }.
          not_to change { User.count }
        expect(User.from_omniauth(mock_github_auth!)).to eq(user)
      end
    end

    context "with an invalid omniauth hash" do
      it "should return an unpersisted user object" do
        user = User.from_omniauth(invalid_mock_github_auth!)
        expect(User.count).to eq(0)
        expect(user).to be_a(User)
        expect(user.persisted?).to eq(false)
      end
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
      expect(user.reload.image).to eq(
        "https://avatars2.githubusercontent.com/u/174825?v=3&s=400"
      )
    end
  end

  describe "#join_enrolling_team!" do
    let(:user) { create(:user) }
    it "should join the enrolling team if the user does not have a team" do
      user.join_enrolling_team!
      expect(user.teams).to include(Team.enrolling.first)
    end
  end
end
