class ExpenseSerializer < ActiveModel::Serializer
  attributes :id, :date, :amount, :description, :comment
  belongs_to :user
end
