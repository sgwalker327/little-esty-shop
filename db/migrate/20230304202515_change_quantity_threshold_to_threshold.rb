class ChangeQuantityThresholdToThreshold < ActiveRecord::Migration[5.2]
  def change
    rename_column :discounts, :quantity_threshold, :threshold
  end
end
