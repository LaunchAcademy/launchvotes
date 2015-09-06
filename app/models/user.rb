class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :trackable, :omniauthable, omniauth_providers: [:github]

  validates :provider, presence: true, inclusion: ["github"]
  validates :uid, presence: true

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.provider = auth.provider
      user.uid = auth.uid
    end
  end

  def update_from_omniauth(auth)
    self.email = auth.info.email
    self.name = auth.info.name
    self.image = auth.info.image
    save
  end
end
