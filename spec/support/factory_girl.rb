require 'factory_girl'

FactoryGirl.define do
  factory :user do
    provider "github"
    sequence(:uid) { |n| n }
    sequence(:email) { |n| "jarlax#{n}@launchacademy.com" }
    sequence(:name) { |n| "Alex Jarvis ##{n}" }
    image "https://avatars2.githubusercontent.com/u/174825?v=3&s=400"
    admin false

    factory :admin_user do
      admin true
    end
  end

  factory :team do
    sequence(:name) { |n| "team ##{n}" }
    enrolling false

    factory :enrolling_team do
      enrolling true
    end
  end

  factory :team_membership do
    user
    team
  end

  factory :nomination do
    association :nominee_membership, factory: :team_membership
    association :nominator, factory: :user
    sequence(:body) { |n| "Best Beard #{n}" }
  end
end
