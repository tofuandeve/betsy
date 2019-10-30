class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product
  
  def quantity_change(order, new_quantity)
    return new_quantity.to_i - self.quantity
  end
end
