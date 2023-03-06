class Invoice < ApplicationRecord
  belongs_to :customer
  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :merchants, through: :items
  
  enum status: [ :in_progress, :completed, :cancelled ]

  def self.incomplete
    joins(:invoice_items)
    .where("invoice_items.status != ?", 2)
    .order(:created_at)
    # question mark is a placeholder for 2
  end

  def items_with_invoice_attributes
    self.invoice_items.joins(:item).select(:quantity, :unit_price, :status, "items.name")
  end

  def calc_total_revenue
    self.invoice_items
    .joins(:item)
    .pluck(Arel.sql("sum(invoice_items.quantity * invoice_items.unit_price) as revenue"))
    .first
  end

  def items_with_attributes
    items
    .select("invoice_items.status as stat, items.*, invoice_items.unit_price as sale_price, invoice_items.quantity as quant")
  end

  def total_inv_disc
    x = invoice_items.joins(item: {merchant: :discounts})
    .where("invoice_items.quantity >= discounts.threshold")
    .group("invoice_items.id")
    .select("MAX(invoice_items.quantity * invoice_items.unit_price * discounts.percent) AS discount_amt")
    x.sum(&:discount_amt)
  end

  def total_disc_rev
    calc_total_revenue - total_inv_disc
  end
end
