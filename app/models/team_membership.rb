class TeamMembership < ActiveRecord::Base
  belongs_to :user
  belongs_to :team
  has_many :nominations,
    foreign_key: "nominee_membership_id",
    dependent: :destroy

  scope :without, -> (user) { where.not(user: user) }

  validates :user, presence: true, uniqueness: { scope: :team }
  validates :team, presence: true, uniqueness: { scope: :user }
end
