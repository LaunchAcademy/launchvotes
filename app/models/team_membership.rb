class TeamMembership < ActiveRecord::Base
  belongs_to :user
  belongs_to :team

  validates :user, presence: true, uniqueness: { scope: :team }
  validates :team, presence: true, uniqueness: { scope: :user }
end
