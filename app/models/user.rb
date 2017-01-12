class User < ApplicationRecord
  has_secure_password
  has_many :expenses, dependent: :destroy
  validates :email, presence: true
  validates :email, uniqueness: true
  validates :email, format: { with: /@{1}/, message: 'should be a valid email address' }
  validates :role, numericality: { only_integer: { less_than_or_equal_to: 2 }, message: 'should be a valid role' }

  default_scope { order('created_at DESC') }

  def avatar_url
    "https://www.gravatar.com/avatar/#{Digest::MD5.hexdigest(self.email)}"
  end

  def is_user_manager?
    role > 0
  end

  def is_admin?
    role > 1
  end

end
