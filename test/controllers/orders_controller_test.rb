require "test_helper"

describe OrdersController do
  describe "new" do
    it "can get the new order page" do
      # Act
      get new_order_path

      # Assert
      must_respond_with :success
    end
  end

  describe "create" do
    it "can create a new order" do
      # Arrange
      order_hash = {
        order: {
          buyer_email: "raccon@raccoon.net",
          buyer_address: "123 raccoon way",
          buyer_name: "Rocky Raccoon",
          buyer_card: "12334577848",
          card_expiration: "12/23",
          cvv: "234",
          zipcode: "98102",
        },
      }

      # Act-Assert
      expect {
        post orders_path, params: order_hash
      }.must_change "Order.count", 1

      new_order = Order.find_by(buyer_name: order_hash[:order][:buyer_name])
      expect(new_order.buyer_email).must_equal order_hash[:order][:buyer_email]
      expect(new_order.buyer_address).must_equal order_hash[:order][:buyer_address]
      expect(new_order.buyer_name).must_equal order_hash[:order][:buyer_name]
      expect(new_order.buyer_card).must_equal order_hash[:order][:buyer_card]
      expect(new_order.card_expiration).must_equal order_hash[:order][:card_expiration]
      expect(new_order.cvv).must_equal order_hash[:order][:cvv]
      expect(new_order.zipcode).must_equal order_hash[:order][:zipcode]

      must_respond_with :redirect
      must_redirect_to order_path(new_order.id)
    end
    
    it "doesn't create a new order for invalid input" do
      bad_order_hash = {}
      expect {
        post orders_path, params: bad_order_hash
      }.must_raise
    end
  end
end
