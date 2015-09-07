require 'rails_helper'

describe Team do
  it { should have_valid(:name).when("Admin Overlords") }
  it { should_not have_valid(:name).when(nil, "") }
  it { should have_valid(:enrolling).when(false, true) }
  it { should_not have_valid(:enrolling).when(nil, "") }
end
