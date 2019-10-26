class Product < ApplicationRecord

  validates :name, presence: true
  
  # def retire_product 
  #   set product status to retire
  # end
end
