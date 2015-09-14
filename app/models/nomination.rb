class Nomination < ActiveRecord::Base
  belongs_to :nominee_membership, class_name: "TeamMembership"
  has_one :nominee, through: :nominee_membership, source: :user
  has_one :team, through: :nominee_membership
  belongs_to :nominator, class_name: "User"

  scope :current_week,
    -> { where("nominations.created_at > ?", Time.current.beginning_of_week) }
  scope :visible_to, -> (user) {
    unless user.admin?
      joins(:nominee_membership).merge(TeamMembership.all_except(user))
    end
  }

  validates :nominee_membership, presence: true
  validates :body, presence: true
end