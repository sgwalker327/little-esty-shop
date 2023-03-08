class Discount < ApplicationRecord
  belongs_to :merchant
  has_many :items, through: :merchant
  has_many :invoice_items, through: :items
  has_many :invoices, through: :invoice_items

  validates :percent, numericality: { greater_than: 0, less_than_or_equal_to: 1 }
  validates :threshold, numericality: { only_integer: true, greater_than_or_equal_to: 1 }
end