class Team < ActiveRecord::Base
  has_many :team_memberships, dependent: :destroy
  has_many :users, through: :team_memberships

  validates :name, presence: true, uniqueness: true
  validates :enrolling, inclusion: { in: [true, false] }
  validate :ensure_enrolling_team, on: :update

  scope :enrolling, -> { where(enrolling: true) }

  before_save do
    Team.enrolling.update_all(enrolling: false) if enrolling
  end

  before_destroy do
    !enrolling?
  end

  private

  def ensure_enrolling_team
    unless enrolling
      errors.add(:enrolling, "There Must Always Be One Enrolling Team")
    end
  end
end
