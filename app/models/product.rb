class Product < ApplicationRecord
  belongs_to :merchant
  has_many :order_items
  validates :name, presence: true
  has_and_belongs_to_many :categories

  def self.list_active
    return Product.where(status: "active")
  end
end

# def retire_product
#   set product status to retire
# end
