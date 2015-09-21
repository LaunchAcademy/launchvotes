class TeamMembership < ActiveRecord::Base
  belongs_to :user
  belongs_to :team
  has_many :nominations,
    foreign_key: "nominee_membership_id",
    dependent: :destroy

  scope :all_except, -> (user) { where.not(user: user) }
  scope :select_options,
    -> { joins(:user).order("users.name").pluck(:name, :id) }

  validates :user, presence: true, uniqueness: { scope: :team }
  validates :team, presence: true, uniqueness: { scope: :user }
end
