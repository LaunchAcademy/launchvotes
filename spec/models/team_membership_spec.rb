require 'rails_helper'

describe TeamMembership do
  it { should belong_to(:user) }
  it { should belong_to(:team) }
  it do
    should have_many(:nominations).
      with_foreign_key("nominee_membership_id").
      dependent(:destroy)
  end

  it { should have_valid(:user).when(User.new) }
  it { should_not have_valid(:user).when(nil) }

  it { should have_valid(:team).when(Team.new) }
  it { should_not have_valid(:team).when(nil) }

  describe ".without" do
    let(:user) { create(:user) }
    let!(:team_membership) { create(:team_membership, user: user) }
    let!(:another_team_membership) { create(:team_membership) }
    it "should return all team memberships without the user" do
      expect(TeamMembership.without(user)).to include(another_team_membership)
      expect(TeamMembership.without(user)).to_not include(team_membership)
    end
  end
end
