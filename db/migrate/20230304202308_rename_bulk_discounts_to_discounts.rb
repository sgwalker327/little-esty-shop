class RenameBulkDiscountsToDiscounts < ActiveRecord::Migration[5.2]
  def change
    rename_table :bulk_discounts, :discounts
  end
end
