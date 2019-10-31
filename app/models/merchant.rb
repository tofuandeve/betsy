class Merchant < ApplicationRecord
  has_many :products
  validates :uid, uniqueness: true, presence: true
  
  def self.build_from_github(auth_hash)
    merchant = Merchant.new
    merchant.uid = auth_hash[:uid]
    merchant.provider = "github"
    merchant.username = auth_hash["info"]["nickname"]
    merchant.email = auth_hash["info"]["email"]
    
    # Note that the user has not been saved.
    # We'll choose to do the saving outside of this method
    return merchant
  end
  
  # This also shows all of the merchant's orders if not given a parameter
  def orders_by_status(status = nil)
    orders = []
    
    self.products.each do |product|   
      product.order_items.each do |item|
        if status
          orders << item.order if (item.order.status == status) && !orders.include?(item.order)
        else
          orders << item.order
        end
      end
    end

    return orders
  end

  def total_revenue
    merchant_products = self.products

    if merchant_products == nil
      return 0
    end

    items = []
    merchant_products.each do |product|
      items << OrderItem.where(product_id: product.id)
    end
    items.flatten!

    if items.empty?
      return 0
    end

    earnings = []
    items.each do |item|
      earnings << item.item_subtotal
    end

    revenue = earnings.sum
    return revenue
  end

  def revenue_by_status(status)
    orders = self.orders_by_status(status)
    earnings = []
    orders.each do |order|
      order.order_items.each do |item|
        product = Product.find_by(id: item.product_id)
        if product.merchant_id == self.id
          earnings << item.item_subtotal
        end
      end
    end

    revenue = earnings.sum
    return revenue
  end

  def number_of_orders_by_status(status)
    orders = self.orders_by_status(status)
    return orders.count
  end
end
