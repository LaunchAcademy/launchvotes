class Team < ActiveRecord::Base
  has_many :team_memberships, dependent: :destroy
  has_many :users, through: :team_memberships
  has_many :nominations, through: :team_memberships

  scope :enrolling, -> { where(enrolling: true) }

  before_save :update_enrolling_teams
  before_destroy :prevent_enrolling_team_destroy

  validates :name, presence: true, uniqueness: true
  validates :enrolling, inclusion: { in: [true, false] }
  validate :ensure_one_enrolling_team, on: :update

  private

  def update_enrolling_teams
    Team.enrolling.update_all(enrolling: false) if enrolling
  end

  def prevent_enrolling_team_destroy
    !enrolling?
  end

  def ensure_one_enrolling_team
    unless enrolling
      errors.add(:enrolling, "must be set on at least one team")
    end
  end
end
