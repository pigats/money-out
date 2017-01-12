class User < ApplicationRecord
  has_secure_password
  has_many :expenses, dependent: :destroy
  validates :email, presence: true
  validates :email, uniqueness: true
  validates :email, format: { with: /@{1}/, message: 'should be a valid email address' }
  validates :role, numericality: { only_integer: { less_than_or_equal_to: 2 }, message: 'should be a valid role' }

  default_scope { order('created_at DESC') }

  before_save :create_confirm_email_token, if: :email_has_changed?
  after_save :send_confirm_email_token, if: :email_has_changed?

  def avatar_url
    "https://www.gravatar.com/avatar/#{Digest::MD5.hexdigest(self.email)}"
  end

  def is_user_manager?
    role > 0
  end

  def is_admin?
    role > 1
  end

  def confirmed?
    self.email_confirm_token.nil?
  end

  def self.generate_token
    Digest::SHA1.hexdigest([Time.now, rand].join)
  end

  private

    def email_has_changed?
      self.email_changed?
    end

    def send_confirm_email_token
      UserMailer.email_confirm(self).deliver
    end

    def create_confirm_email_token
      self.email_confirm_token = User.generate_token
    end
end
