class Order < ApplicationRecord
  has_many :order_items
  validates :buyer_email, presence: true, on: :update
  validates :buyer_address, presence: true, on: :update
  validates :buyer_name, presence: true, on: :update
  validates :buyer_card, presence: true, on: :update
  validates :card_expiration, presence: true, on: :update
  validates :cvv, presence: true, on: :update
  validates :zipcode, presence: true, on: :update
  
  def find_order_item_by_product_id(product_id)
    self.order_items.each do |item|
      if item.product_id == product_id
        return item
      end
    end
    return nil
  end
  
  def checkout
    items = self.order_items
    items.each do |item|
      product = item.product
      product.update_stock(item.quantity)
      product.save
    end
    return true
  end
end
