class User < ApplicationRecord
  has_secure_password
  validates :email, presence: true
  validates :email, uniqueness: true
  validates :email, format: { with: /@{1}/, message: 'should be a valid email address' }

  has_many :expenses

  def avatar_url
    "https://www.gravatar.com/avatar/#{Digest::MD5.hexdigest(self.email)}"
  end

  def is_user_manager
    true
  end

  def is_admin
    false
  end
end
