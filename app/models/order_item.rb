class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product
  validates :quantity, presence: true, numericality: { greater_than: 0, message: "Please enter a price using numbers" }

  def quantity_change(order, new_quantity)
    return new_quantity.to_i - self.quantity
  end

  def item_subtotal
    quantity = self.quantity
    product = Product.find_by(id: self.product_id)

    if product == nil
      return 0
    elsif product.price == nil
      return 0
    elsif product.price.class != Integer && product.price.class != Float
      return 0
    else
      price = product.price
    end

    subtotal = quantity * price
    return subtotal
  end

  def toggle_shipped
    self.shipped_status = (self.shipped_status == "not_shipped") ? "shipped" : "not_shipped"
  end
end
