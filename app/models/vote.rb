class Vote < ActiveRecord::Base
  belongs_to :nomination
  belongs_to :voter, class_name: "User"

  validates :nomination, presence: true
  validates :voter, presence: true
end
