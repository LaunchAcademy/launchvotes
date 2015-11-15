class Nomination < ActiveRecord::Base
  PLACEHOLDERS = [
    "Most glorious beard",
    "Best flow",
    "Most help requests",
    "Fastest typer",
    "Best spectacles",
    "Best accent",
    "Most likely to `git push origin master -f`",
    "Breakable toy is funded on Kickstarter"
  ]
  belongs_to :nominee_membership, class_name: "TeamMembership"
  has_one :nominee, through: :nominee_membership, source: :user
  has_one :team, through: :nominee_membership
  belongs_to :nominator, class_name: "User"
  has_many :votes, dependent: :destroy
  has_many :voters, through: :votes, source: :voter

  scope :current_week,
    -> { where("nominations.created_at > ?", Time.current.beginning_of_week) }
  scope :previous_weeks,
    -> { where("nominations.created_at < ?", Time.current.beginning_of_week) }
  scope :visible_to, -> (user) {
    unless user.admin?
      joins(:nominee_membership).merge(TeamMembership.all_except(user))
    end
  }
  scope :awards, -> {
    select("nominations.*, count(votes.id) AS votes_count").
    joins(:votes).
    group("nominations.id").
    order("votes_count")
  }

  validates :nominee_membership, presence: true
  validates :body, presence: true
end
