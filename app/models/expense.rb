class Expense < ApplicationRecord
  belongs_to :user
  validates :description, :amount, presence: true
  validates :amount, numericality: { other_than: 0 }
end
