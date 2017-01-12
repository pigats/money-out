class UserMailer < ApplicationMailer
  def password_reset user
    @user = user
    mail(to: @user.email, subject: 'Password Reset for MoneyOut')
  end

  def email_confirm user
    @user = user
    mail(to: @user.email, subject: 'Email Confirm for MoneyOut')
  end
end
