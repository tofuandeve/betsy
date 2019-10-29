class Product < ApplicationRecord
  belongs_to :merchant
  has_many :order_items
  validates :name, presence: true

  def self.list_active
    return Product.where(status: "active")
  end

  def decrease_stock
    if self.stock > 0
      self.stock -= 1
      return true
    else
      return false
    end
  end

  def toggle_retired
    if self.status == "active"
      self.status = "retired"
    else
      self.status = "active"
    end
  end

  def in_stock?
    if self.stock > 0
      return true
    else
      return false
    end
  end
end
  