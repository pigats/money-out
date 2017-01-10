class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :avatar_url
  has_many :expenses do
    include_data false unless object.expenses.loaded
    link(:related) { user_expenses_url(user_id: object.id) }
  end
end
