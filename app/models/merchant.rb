class Merchant < ApplicationRecord
  has_many :items
  has_many :discounts
  has_many :invoice_items, through: :items
  has_many :invoices, through: :invoice_items
  has_many :transactions, through: :invoices
  has_many :customers, through: :invoices
  
  validates :name, presence: true

  enum status: [:disabled, :enabled]

  def top_five_customers
    customers.joins(:transactions)
    .where(transactions: {result: 'success'})
    .select("customers.*, count(DISTINCT transactions.id) as transaction_count")
    .group("customers.id")
    .order("transaction_count desc").limit(5)
  end
  
  def self.top_5_by_revenue
   Merchant.joins(:transactions)
   .where("transactions.result = 'success'")
   .group("merchants.id")
   .select("merchants.*, sum(invoice_items.quantity * invoice_items.unit_price) AS revenue")
   .order("revenue desc")
   .limit(5)
 end

  def items_ready_to_ship
    Item.joins(:invoices)
    .where("invoice_items.status = ?", 0)
    .order("invoices.created_at asc")
    .select("items.*, invoices.created_at as inv_time")
  end

  def best_revenue_day
    self.invoices.joins(:transactions)
    .where("transactions.result = 'success'")
    .select("invoices.created_at, sum(invoice_items.quantity * invoice_items.unit_price) AS revenue")
    .group("invoices.created_at")
    .order("revenue desc")
    .order("invoices.created_at asc")
    .limit(1)
    .first
  end
end
