class Team < ActiveRecord::Base
  has_many :memberships, class_name: "TeamMembership", dependent: :destroy
  has_many :users, through: :memberships
  has_many :nominations, through: :memberships

  scope :enrolling, -> { where(enrolling: true) }

  before_save :update_enrolling_teams
  before_destroy :prevent_enrolling_team_destroy

  validates :name, presence: true, uniqueness: true
  validates :enrolling, inclusion: { in: [true, false] }
  validate :ensure_one_enrolling_team, on: :update

  private

  def update_enrolling_teams
    if enrolling
      Team.enrolling.update_all(enrolling: false)
      update_columns(enrolling: true) if persisted?
    end
  end

  def prevent_enrolling_team_destroy
    !enrolling?
  end

  def ensure_one_enrolling_team
    if Team.enrolling.include?(self) && !enrolling
      errors.add(:enrolling, "must be set on at least one team")
    end
  end
end
