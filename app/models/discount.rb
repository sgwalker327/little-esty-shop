class Discount < ApplicationRecord
  belongs_to :merchant

  validates_numericality_of :percent, :threshold
end