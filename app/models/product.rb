class Product < ApplicationRecord
  belongs_to :merchant
  has_many :order_items
  validates :name, presence: true
  has_and_belongs_to_many :categories
  has_many :reviews

  def self.list_active
    return Product.where(status: "active")
  end

  def update_stock(quantity)
    if quantity > 0
      decrease_stock(quantity)
    else
      increase_stock(quantity)
    end
  end

  def decrease_stock(quantity)
    if self.stock >= quantity
      self.stock -= quantity
      return true
    else
      return false
    end
  end

  def increase_stock(quantity)
    self.stock += quantity
    return true
  end

  def toggle_retired
    self.status = (self.status == "active") ? "retired" : "active"
  end

  def in_stock?
    return self.stock > 0
  end
end
