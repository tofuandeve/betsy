class AddShippedStatusToOrderitem < ActiveRecord::Migration[5.2]
  def change
    add_column :order_items, :shipped_status, :string, :default => "not_shipped"
  end
end
