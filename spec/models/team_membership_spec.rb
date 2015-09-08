require 'rails_helper'

describe TeamMembership do
  it { should belong_to(:user) }
  it { should belong_to(:team) }

  it { should have_valid(:user).when(User.new) }
  it { should_not have_valid(:user).when(nil) }

  it { should have_valid(:team).when(Team.new) }
  it { should_not have_valid(:team).when(nil) }
end
