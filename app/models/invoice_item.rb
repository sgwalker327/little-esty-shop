class InvoiceItem < ApplicationRecord
  belongs_to :invoice
  belongs_to :item
  has_many :discounts, through: :item
  
  enum status: [ :packaged, :pending, :shipped ]
end
