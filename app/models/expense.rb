class Expense < ApplicationRecord
  belongs_to :user
  validates :description, :amount, presence: true
  validates :amount, numericality: { other_than: 0 }

  default_scope { order('date DESC') }
  scope :dates_between, ->(range) { where(date: range) if range.present? }
  scope :amount_between, ->(range) { where(amount: range) if range.present? }
  scope :description_like, -> (keyword) { where('description LIKE ?', "%#{keyword}%") if keyword.present? }
end
