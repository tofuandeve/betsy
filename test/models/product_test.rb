require "test_helper"

describe Product do
  describe "list_active" do
    it "does not list products with retired status" do
      products = Product.list_active
    
      products.each do |product|
        expect _(product.status).must_equal "active" 
      end
    end
  end

  describe "decrease_stock" do
    it "decreases the given product's stock by the given quantity" do
      current_product = products(:product1)
      expect(current_product.stock).must_equal 14
      
      expect(current_product.decrease_stock(1)).must_equal true
      expect(current_product.stock).must_equal 13
    end

    it "does not decrease the stock if it is already 0 and returns false" do
      current_product = products(:out_of_stock_product)
      expect(current_product.stock).must_equal 0

      expect(current_product.decrease_stock(1)).must_equal false
      expect(current_product.stock).must_equal 0
    end
  end

  describe "increase_stock" do
    it "increases the given product's stock by 1" do
      current_product = products(:product1)
      expect(current_product.stock).must_equal 14

      current_product.increase_stock(2)
      expect(current_product.stock).must_equal 16
    end
  end

  describe "toggle_retired" do
    it "changes the product's status to retired if it was previously active" do
      current_product = products(:product1)
      expect(current_product.status).must_equal "active"
      current_product.toggle_retired
      expect(current_product.status).must_equal "retired"
    end

    it "changes the product's status to active if it was previously retired" do
      current_product = products(:retired_product)
      expect(current_product.status).must_equal "retired"
      current_product.toggle_retired
      expect(current_product.status).must_equal "active"
    end
  end

  describe "in_stock?" do
    it "returns true if given a valid product that has items in stock" do
      current_product = products(:product1)
      expect(current_product.in_stock?).must_equal true
    end
    
    it "returns false if the current product is out of stock" do
      current_product = products(:out_of_stock_product)
      expect(current_product.in_stock?).must_equal false
    end
  end
end
