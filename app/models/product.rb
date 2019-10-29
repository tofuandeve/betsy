class Product < ApplicationRecord
  belongs_to :merchant
  validates :name, presence: true

  def self.list_active
    return Product.where(status: "active")
  end

end



 # def retire_product 
  #   set product status to retire
  # end

  