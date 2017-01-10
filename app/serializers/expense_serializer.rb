class ExpenseSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :date, :amount, :description, :comment
end
