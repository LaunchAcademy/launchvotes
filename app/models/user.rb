class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :trackable, :omniauthable, omniauth_providers: [:github]

  has_many :team_memberships, dependent: :destroy
  has_many :teams, through: :team_memberships

  validates :provider, presence: true, inclusion: { in: ["github"] }
  validates :uid, presence: true

  scope :nominees, -> (user) { where.not(id: user.id) }
  scope :nonmembers, -> (team) { where.not(id: team.users.pluck(:id)) }

  def self.from_omniauth(auth)
    find_or_create_by(provider: auth.provider, uid: auth.uid)
  end

  def update_from_omniauth(auth)
    self.email = auth.info.email
    self.name = auth.info.name
    self.image = auth.info.image
    save
  end
end
