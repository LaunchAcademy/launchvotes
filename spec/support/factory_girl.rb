require 'factory_girl'

FactoryGirl.define do
  factory :user do
    provider "github"
    sequence (:uid) { |n| n }
    sequence(:email) { |n| "jarlax#{n}@launchacademy.com" }
    sequence(:name) { |n| "Alex Jarvis ##{n}" }
    image "https://avatars2.githubusercontent.com/u/174825?v=3&s=400"
  end
end
