class User < ApplicationRecord
  has_secure_password
  validates :email, presence: true
  validates :email, uniqueness: true
  validates :email, format: { with: /@{1}/, message: 'should be a valid email address' }
end
