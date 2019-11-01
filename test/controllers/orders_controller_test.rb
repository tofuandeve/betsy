require "test_helper"

describe OrdersController do
  before do
    @valid_order = Order.create(
      buyer_email: "raccon@raccoon.net",
      buyer_address: "123 raccoon way",
      buyer_name: "Rocky Raccoon",
      buyer_card: "12334577848",
      card_expiration: "12/23",
      cvv: "234",
      zipcode: "98102"
    )
  end
  
  describe "new" do
    it "can get the new order page and responds with success" do
      # Act
      get new_order_path
      
      # Assert
      must_respond_with :success
    end
  end
  
  describe "create" do
    it "can create a new order and redirects to the order_path" do
      # Arrange
      order_hash = {
        order: {
          buyer_email: "raccon@raccoon.net",
          buyer_address: "123 raccoon way NEW",
          buyer_name: "Rocky Raccoon NEW",
          buyer_card: "12334567890",
          card_expiration: "12/24",
          cvv: "239",
          zipcode: "98103",
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
      start_count = Order.count
      expect {
        post orders_path, params: bad_order_hash
      }.must_raise
      
      expect (Order.count).must_equal start_count
    end
  end
  
  describe "edit" do
    it "can get the edit page for an existing order" do
      get edit_order_path(@valid_order.id)
      
      must_respond_with :success
    end
    
    it "will redirect to root_path when attempting to edit a nonexistant order" do
      get edit_order_path(-1)
      
      must_redirect_to root_path
    end
  end
  
  describe "update" do
    before do 
      @order_hash = {
        order: {
          buyer_email: "raccon@raccoon.net",
          buyer_address: "123 raccoon way VERY UPDATED",
          buyer_name: "Rocky Raccoon Jr.",
          buyer_card: "12334577848",
          card_expiration: "12/23",
          cvv: "234",
          zipcode: "98102",
        },
      }
    end
    
    it "can update an existing order and redirect to order show page" do
      existing_order = Order.find_by(id: @valid_order[:id])
      
      expect { 
        patch order_path(existing_order.id), params: @order_hash
      }.must_differ "Order.count", 0
      
      existing_order = Order.find_by(id: existing_order.id)
      expect _(existing_order.buyer_address).must_equal @order_hash[:order][:buyer_address]
      expect _(existing_order.buyer_name).must_equal @order_hash[:order][:buyer_name]
      
      must_respond_with :redirect
      must_redirect_to edit_order_path(existing_order.id)  
    end
    
    it "will redirect to root_path if given an invalid id" do
      expect {
        patch order_path(-1), params: @order_hash
      }.must_differ "Order.count", 0
      
      must_redirect_to root_path
    end
    
    it "must not update order if given an invalid info" do
      updated_order_hashes = [
        {
          order: {
            buyer_email: "",
            buyer_address: "",
            buyer_name: "",
            buyer_card: "",
            card_expiration: "",
            cvv: "",
            zipcode: "",
          }
        },
        {
          order: {
            buyer_email: nil,
            buyer_address: nil,
            buyer_name: nil,
            buyer_card: nil,
            card_expiration: nil,
            cvv: nil,
            zipcode: nil,
          },
        }
      ]
      
      updated_order_hashes.each do |hash|
        expect {
          patch order_path(@valid_order.id), params: hash
        }.must_differ "Order.count", 0
      end
      
      existing_order = Order.find_by(id: @valid_order.id)
      expect _(existing_order.buyer_email).must_equal @valid_order.buyer_email
      expect _(existing_order.buyer_address).must_equal @valid_order.buyer_address
      expect _(existing_order.buyer_name).must_equal @valid_order.buyer_name
      expect _(existing_order.buyer_card).must_equal @valid_order.buyer_card
      expect _(existing_order.card_expiration).must_equal @valid_order.card_expiration
      expect _(existing_order.cvv).must_equal @valid_order.cvv
      expect _(existing_order.zipcode).must_equal @valid_order.zipcode
    end
  end
  
  describe "destroy" do
    it "can destroy an existing order and redirect to root path" do
      expect _(Order.count).must_equal 1
      
      expect {
        delete order_path(@valid_order.id)
      }.must_differ "Order.count", -1
      
      assert_nil (Order.find_by(id: @valid_order.id))
      must_respond_with :redirect
      must_redirect_to root_path
    end
    
    it "will redirect to the root path if given an invalid id" do
      expect {
        delete order_path(-1)
      }.must_differ "Order.count", 0
      
      must_respond_with :redirect
      must_redirect_to root_path
    end
  end

  describe "cancel" do
    before do
      @merchant = perform_login
      @product = Product.create( 
        name: "trashgarbage",
        status: "active",
        description: "nice and slimy, beautiful and rotten",
        price: 12,
        stock: 14,
        photo_url: "https://imgur.com/eggshells4life",
        merchant_id: @merchant.id
      )
      Order.destroy_all
      OrderItem.destroy_all
      
      post add_to_cart_path(@product.id)
      @order = Order.first
      @order_item = OrderItem.first 
      @order.update(
        buyer_email: "raccon@raccoon.net",
        buyer_address: "123 raccoon way",
        buyer_name: "Rocky Raccoon",
        buyer_card: "12334577848",
        card_expiration: "12/23",
        cvv: "234",
        zipcode: "98102"
      )
      patch place_order_path(@order.id)
    end

    it "a logged in user can cancel an order (very controversial thing to do but ok)" do
      order_id = @order.id
      expect _(Order.find_by(id: order_id).status).must_equal "paid"
      patch cancel_path(order_id)

      expect _(Order.find_by(id: order_id).status).must_equal "cancelled"      
    end
  end
end
