require "test_helper"

describe Product do

  it "does not list products with retired status" do
    products = Product.list_active
  
    products.each do |product|
      expect _(product.status).must_equal "active" 
    end
  end

end
