class Product < ApplicationRecord
  belongs_to :merchant
  has_many :order_items, dependent: :nullify
  has_and_belongs_to_many :categories, dependent: :nullify
  has_many :reviews, dependent: :nullify
  
  validates :name, presence: true
  validates :photo_url, presence: true, format: { with: /https:\/\/.*/, message: "Please enter a photo url beginning with 'https://'" }
  validates :price, presence: true, numericality: { greater_than: 0 }, format: { with: /^[0-9]*\.?[0-9]*/, multiline: true, message: "Please enter a price using numbers" }

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
