class Team < ActiveRecord::Base
  has_many :team_memberships, dependent: :destroy
  has_many :users, through: :team_memberships

  validates :name, presence: true, uniqueness: true
  validates :enrolling, inclusion: { in: [true, false] }

  scope :enrolling, -> { where(enrolling: true) }

  before_save do
    Team.enrolling.update_all(enrolling: false) if enrolling
  end
end
