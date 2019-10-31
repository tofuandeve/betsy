require "test_helper"

describe OrderItem do

  describe "item_subtotal" do
    let(:valid_merchant1) { merchants(:merchant1) }
    let(:valid_merchant2) { merchants(:merchant2) }

    before do
      product = products(:product1)
      valid_product = Product.create(
        name: product.name,
        status: product.status,
        description: product.description,
        price: product.price,
        stock: product.stock,
        photo_url: product.photo_url,
        merchant_id: valid_merchant1.id 
      )
        
      valid_order = Order.create(
        buyer_email: "raccon@raccoon.net",
        buyer_address: "123 raccoon way",
        buyer_name: "Rocky Raccoon Jr.",
        buyer_card: "12334577848",
        card_expiration: "12/23",
        cvv: "234",
        zipcode: "98102"
      )
        
      @valid_order_item = OrderItem.new(quantity: 3)
      @valid_order_item.product = valid_product
      @valid_order_item.order = valid_order
      @valid_order_item.save
    end

    it "returns the subtotal for the given OrderItem when given a valid price" do
      expect(@valid_order_item.item_subtotal).must_equal 36
    end

    it "returns 0 when the quantity of the OrderItem is 0" do
      @valid_order_item.product = nil
      @valid_order_item.save

      expect(@valid_order_item.item_subtotal).must_equal 0
    end

    it "returns 0 when the product is nil" do
      @valid_order_item.quantity = 0
      @valid_order_item.save

      expect(@valid_order_item.item_subtotal).must_equal 0
    end

    it "returns 0 when the product price is nil" do
      @valid_order_item.product.price = nil
      @valid_order_item.product.save
      
      expect(@valid_order_item.item_subtotal).must_equal 0
    end

    it "returns 0 when the product price is not a number" do
      @valid_order_item.product.price = "abc"
      @valid_order_item.product.save
      
      expect(@valid_order_item.item_subtotal).must_equal 0
    end
  end
end
