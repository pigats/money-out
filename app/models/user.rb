class User < ApplicationRecord
  has_secure_password
  validates :email, presence: true
  validates :email, uniqueness: true
  validates :email, format: { with: /@{1}/, message: 'should be a valid email address' }

  def avatar_url
    "https://www.gravatar.com/avatar/#{Digest::MD5.hexdigest(self.email)}"
  end

  def is_user_manager
    true
  end

  def as_json(options)
    super(options.merge(except: 'password_digest', methods: :avatar_url))
  end
end
