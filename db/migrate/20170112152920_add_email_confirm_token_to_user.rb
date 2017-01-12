class AddEmailConfirmTokenToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :email_confirm_token, :string
  end
end
