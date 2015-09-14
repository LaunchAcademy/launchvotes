require 'rails_helper'

describe Vote do
  it { should belong_to(:nomination) }
  it { should belong_to(:voter).class_name("User") }

  it { should have_valid(:nomination).when(Nomination.new) }
  it { should_not have_valid(:nomination).when(nil) }

  it { should have_valid(:voter).when(User.new) }
  it { should_not have_valid(:voter).when(nil) }
end
