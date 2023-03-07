class InvoiceItem < ApplicationRecord
  belongs_to :invoice
  belongs_to :item
  has_many :discounts, through: :item
  
  enum status: [ :packaged, :pending, :shipped ]

  def top_discount
    discounts
    .where("threshold <= ?", quantity)
    .order(percent: :desc)
    .first
  end
end
