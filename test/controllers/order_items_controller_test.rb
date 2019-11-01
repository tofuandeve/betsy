require "test_helper"

describe OrderItemsController do
  let(:valid_product1) { products(:product1) }
  let(:valid_product2) { products(:product2) }
  let(:no_stock) { products(:out_of_stock_product) }
  
  describe "create action" do
    it "can make a new cart to add a product to cart and redirects back to product show view" do
      Order.destroy_all
      OrderItem.destroy_all
      expect _(Order.count).must_equal 0
      
      expect {
        post add_to_cart_path(valid_product1.id)
      }.must_differ "OrderItem.count", 1
      expect _(Order.count).must_equal 1
      
      cart = Order.first
      expect _(OrderItem.first.order).must_equal cart
      expect _(cart.order_items.count).must_equal 1
      must_redirect_to product_path(valid_product1.id)
    end
    
    it "can add many different products to current cart and redirects back to product show view" do
      Order.destroy_all
      OrderItem.destroy_all
      expect _(Order.count).must_equal 0
      
      expect {
        post add_to_cart_path(valid_product1.id)
      }.must_differ "OrderItem.count", 1
      cart = Order.first
      
      expect {
        post add_to_cart_path(valid_product2.id)
      }.must_differ "OrderItem.count", 1
      
      cart = Order.find_by(id: cart.id)
      expect _(Order.count).must_equal 1
      expect _(cart.order_items.count).must_equal 2
      must_redirect_to product_path(valid_product2.id)
    end
    
    it "can add same product to current cart and redirects back to product show view" do
      Order.destroy_all
      OrderItem.destroy_all
      expect _(Order.count).must_equal 0
      
      expect {
        post add_to_cart_path(valid_product1.id)
      }.must_differ "OrderItem.count", 1
      cart = Order.first
      order_item = OrderItem.first
      expect _(order_item.product).must_equal valid_product1
      expect _(order_item.quantity).must_equal 1
      
      expect {
        post add_to_cart_path(valid_product1.id)
      }.must_differ "OrderItem.count", 0
      order_item = OrderItem.first
      
      cart = Order.find_by(id: cart.id)
      expect _(Order.count).must_equal 1
      expect _(cart.order_items.count).must_equal 1
      expect _(order_item.quantity).must_equal 2
      must_redirect_to product_path(valid_product1.id)
    end
    
    it "won't add a product to current cart if there isn't enough stock and redirects back to product show view" do
      Order.destroy_all
      OrderItem.destroy_all
      product = products(:product3)
      expect _(Order.count).must_equal 0
      
      expect {
        post add_to_cart_path(product.id)
      }.must_differ "OrderItem.count", 1
      cart = Order.first
      order_item = OrderItem.first
      expect _(order_item.product).must_equal product
      expect _(order_item.quantity).must_equal 1
      
      expect {
        post add_to_cart_path(product.id)
      }.must_differ "OrderItem.count", 0
      order_item = OrderItem.first
      
      cart = Order.find_by(id: cart.id)
      expect _(Order.count).must_equal 1
      expect _(cart.order_items.count).must_equal 1
      expect _(order_item.quantity).must_equal 1
      must_redirect_to product_path(product.id)
    end
    
    it "redirects back to product show view if given a product that is out of stock" do
      expect {
        post add_to_cart_path(no_stock.id)
      }.must_differ "OrderItem.count", 0
      
      must_redirect_to product_path(no_stock.id)
    end
    
    it "redirects back to product show view if given a product that is retired" do
      expect {
        post add_to_cart_path(products(:retired_product).id)
      }.must_differ "OrderItem.count", 0
      
      must_redirect_to product_path(products(:retired_product).id)
    end
    
    it "redirects back to product index view if given an invalid product id" do
      expect {
        post add_to_cart_path(-1)
      }.must_differ "OrderItem.count", 0
      
      must_redirect_to products_path
    end
  end
  
  describe "update action" do
    before do
      @updated_order_item_hash = {
        order_item: {
          quantity: 12,
        },
      }
    end
    
    it "redirects back to cart show view if given an invalid order item id" do
      expect {
        patch order_item_path(-1)
      }.must_differ "OrderItem.count", 0
      
      must_redirect_to products_path

      expect { patch }
    end
    
    it "updates quantity for order item in cart and redirects back to cart show view" do
      Order.destroy_all
      OrderItem.destroy_all
      post add_to_cart_path(valid_product1.id)
      cart = Order.first
      current_item = cart.order_items.first
      start_quantity = current_item.quantity
      
      expect {
        patch order_item_path(current_item.id), params: @updated_order_item_hash
      }.must_differ "OrderItem.count", 0
      
      cart = Order.find_by(id: cart.id)
      current_item = OrderItem.find_by(id: current_item.id)
      expect _(cart.order_items.count).must_equal 1
      expect _(current_item.quantity).must_equal @updated_order_item_hash[:order_item][:quantity]
      
      must_redirect_to order_path(cart.id)
    end
    
    it "won't update quantity for order item in cart if there's not enough product and redirects back to cart show view" do
      post add_to_cart_path(valid_product2.id)
      cart = Order.first
      current_item = cart.order_items.first
      start_quantity = current_item.quantity
      
      expect {
        patch order_item_path(current_item.id), params: @updated_order_item_hash
      }.must_differ "OrderItem.count", 0
      
      cart = Order.find_by(id: cart.id)
      current_item = OrderItem.find_by(id: current_item.id)
      expect _(cart.order_items.count).must_equal 1
      expect _(current_item.quantity).must_equal 1
      must_redirect_to order_path(cart.id)
    end
  end
  
  describe "destroy action" do
    it "can destroy an existing order item and redirect to order show view" do
      order = Order.create()
      order_item = OrderItem.create(order_id: order.id, product_id: valid_product1.id, quantity: 2)
      
      expect {
        delete order_item_path(order_item.id)
      }.must_differ "OrderItem.count", -1
      
      must_redirect_to products_path
      assert_nil(OrderItem.find_by(id: order_item.id))
    end
    
    it "redirects to order show view and won't affect OrderItem data if given invalid order item id" do
      expect {
        delete order_item_path(-1)
      }.must_differ "OrderItem.count", 0
      
      must_redirect_to order_path
    end
  end
  
  describe "logged out user mark_shipped action" do 
    it "requires user to log in to mark item as shipped" do
      order = Order.create
      order_item = OrderItem.create(
        product_id: products(:product1).id,
        order_id: order.id,
        quantity: 1,
        shipped_status: "not_shipped"
      )
      expect _(order_item.shipped_status).must_equal "not_shipped"
      
      patch mark_shipped_path(order_item.id)
      expect _(order_item.shipped_status).must_equal "not_shipped"
      must_redirect_to root_path
    end
    
  end
  
  describe "logged in user mark_shipped action" do
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
    
    it "can mark an order item as shipped and redirects to merchant dashboard" do
      expect _(@order_item.shipped_status).must_equal "not_shipped"
      
      patch mark_shipped_path(@order_item.id)
      
      @order_item = OrderItem.find_by(id: @order_item.id)
      
      expect _(OrderItem.find_by(id: @order_item.id).shipped_status).must_equal "shipped" 
      must_redirect_to merchant_path(@merchant.id)
    end
    
    it "can update order status as complete when all order item are shipped and redirects to merchant dashboard" do
      expect _(@order_item.shipped_status).must_equal "not_shipped"
      expect _(Order.find_by(id: @order.id).status).must_equal "paid"
      
      patch mark_shipped_path(@order_item.id)
      
      @order_item = OrderItem.find_by(id: @order_item.id)
      expect _(@order_item.shipped_status).must_equal "shipped" 
      expect _(Order.find_by(id: @order.id).status).must_equal "complete"
      must_redirect_to merchant_path(@merchant.id)
      
    end
    
    it "won't change order item status and redirects to products index page if given an invalid order item id" do
      expect _(@order_item.shipped_status).must_equal "not_shipped"
      
      patch mark_shipped_path(-1)
      must_redirect_to products_path
    end
  end
end
