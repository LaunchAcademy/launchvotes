require 'rails_helper'

describe Nomination do
  it { should belong_to(:nominee_membership).class_name("TeamMembership") }
  it { should have_one(:nominee).through(:nominee_membership).source(:user) }
  it { should have_one(:team).through(:nominee_membership) }
  it { should belong_to(:nominator).class_name("User") }
  it { should have_many(:votes).dependent(:destroy) }
  it { should have_many(:voters).through(:votes).source(:voter) }

  it { should have_valid(:nominee_membership).when(TeamMembership.new) }
  it { should_not have_valid(:nominee_membership).when(nil) }
  it { should have_valid(:body).when("Best Man Bun") }
  it { should_not have_valid(:body).when(nil, "") }

  describe ".current_week" do
    let!(:last_week_nomination) { create(:nomination, created_at: 1.week.ago) }
    let!(:current_week_nomination) { create(:nomination) }
    it "should return nominations created after the beginning of the week" do
      expect(Nomination.current_week).to include(current_week_nomination)
      expect(Nomination.current_week).to_not include(last_week_nomination)
    end
  end

  describe ".previous_weeks" do
    let!(:last_week_nomination) { create(:nomination, created_at: 1.week.ago) }
    let!(:current_week_nomination) { create(:nomination) }
    it "should return nominations created before the beginning of the week" do
      expect(Nomination.previous_weeks).to include(last_week_nomination)
      expect(Nomination.previous_weeks).to_not include(current_week_nomination)
    end
  end

  describe ".visible_to" do
    let(:team) { create(:team) }
    let(:user) { create(:user) }
    let(:admin) { create(:admin_user) }
    let(:team_membership) { create(:team_membership, user: user) }
    let(:another_team_membership) { create(:team_membership, user: admin) }
    let!(:nomination) do
      create(:nomination, nominee_membership: team_membership)
    end
    let!(:another_nomination) do
      create(:nomination, nominee_membership: another_team_membership)
    end

    it "should not show nominations where the user is the nominee" do
      expect(Nomination.visible_to(user)).to_not include(nomination)
      expect(Nomination.visible_to(user)).to include(another_nomination)
    end

    it "should show all nominations if the user is an admin" do
      expect(Nomination.visible_to(admin)).
        to include(nomination, another_nomination)
    end
  end

  describe ".awards" do
    let!(:nomination_with_most_votes) { create(:nomination) }
    let!(:votes) do
      create_list(:vote, 2, nomination: nomination_with_most_votes)
    end
    let!(:nomination_with_least_votes) { create(:nomination) }
    let!(:vote) { create(:vote, nomination: nomination_with_least_votes) }
    let!(:nomination_without_vote) { create(:nomination) }
    it "should show Nominations with at least one vote" do
      expect(Nomination.awards).to include(
        nomination_with_most_votes, nomination_with_least_votes
      )
      expect(Nomination.awards).to_not include(nomination_without_vote)
    end

    it "should show nominations only once" do
      expect(Nomination.awards.to_a.size).to eq(2)
    end

    it "should show order nominations by vote count" do
      expect(Nomination.awards.first).to eq(nomination_with_least_votes)
      expect(Nomination.awards.last).to eq(nomination_with_most_votes)
    end
  end
end
