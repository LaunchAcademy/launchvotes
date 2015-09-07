require 'rails_helper'

describe Team do
  it { should have_valid(:name).when("Admin Overlords") }
  it { should_not have_valid(:name).when(nil, "") }
  it { should have_valid(:enrolling).when(false, true) }
  it { should_not have_valid(:enrolling).when(nil, "") }

  describe ".enrolling" do
    let!(:not_enrolling_team) { create(:team) }
    let!(:enrolling_team) { create(:enrolling_team) }
    it "should return teams which are enrolling" do
      expect(Team.enrolling).to include(enrolling_team)
      expect(Team.enrolling).to_not include(not_enrolling_team)
    end
  end
end
