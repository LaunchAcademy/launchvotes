class Team < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true
  validates :enrolling, inclusion: { in: [true, false] }
end
