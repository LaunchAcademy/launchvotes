require 'rails_helper'

describe Team do
  it do
    should have_many(:memberships).
      class_name("TeamMembership").
      dependent(:destroy)
  end
  it { should have_many(:users).through(:memberships) }
  it { should have_many(:nominations).through(:memberships) }

  it { should have_valid(:name).when("Admin Overlords") }
  it { should_not have_valid(:name).when(nil, "") }
  it { should validate_uniqueness_of(:name) }

  it { should have_valid(:enrolling).when(false, true) }
  it { should_not have_valid(:enrolling).when(nil, "") }

  context "with existing enrolling team and nonenrolling teams" do
    let!(:original_nonenrolling_team) { create(:team) }
    let!(:original_enrolling_team) { create(:enrolling_team) }

    describe ".enrolling" do
      it "should return teams which are enrolling" do
        expect(Team.enrolling).to include(original_enrolling_team)
        expect(Team.enrolling).to_not include(original_nonenrolling_team)
      end
    end

    describe ".create" do
      it "should make all other teams nonenrolling if an enrolling team is created" do
        new_team = Team.create(name: "Smurfs 13 League", enrolling: true)
        expect(original_nonenrolling_team.reload.enrolling).to be false
        expect(original_enrolling_team.reload.enrolling).to be false
        expect(new_team.enrolling).to be true
      end
    end

    describe "#update" do
      it "should make all other teams nonenrolling if a team is made enrolling" do
        original_nonenrolling_team.update(enrolling: true)
        expect(original_nonenrolling_team.enrolling).to be true
        expect(original_enrolling_team.reload.enrolling).to be false
      end

      it "should prevent the enrolling team from becoming unenrolling" do
        original_enrolling_team.update(enrolling: false)
        expect(original_nonenrolling_team.reload.enrolling).to be false
        expect(original_enrolling_team.reload.enrolling).to be true
        expect(original_enrolling_team.errors.full_messages).to include(
          "Enrolling must be set on at least one team"
        )
      end
    end

    describe "#destroy" do
      it "should not allow an enrolling team to be destroyed" do
        original_enrolling_team.destroy
        expect { original_enrolling_team.reload }.not_to raise_error
      end
    end
  end
end
