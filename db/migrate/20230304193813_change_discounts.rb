class ChangeDiscounts < ActiveRecord::Migration[5.2]
  change_table :bulk_discounts do |t|
    t.rename :discount, :percent
    
    t.timestamps
  end
end
