require "test_helper"

describe OrderItemsController do
  let(:valid_product1) { products(:product1)}
  let(:valid_product2) { products(:product2)}
  let(:no_stock) { products(:out_of_stock_product)}
  
  describe "create action" do
    it "can make a new cart to add a product to cart and redirecst back to product show view" do
      Order.destroy_all
      OrderItem.destroy_all
      expect _(Order.count).must_equal 0
      
      expect{
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
      
      expect{
        post add_to_cart_path(valid_product1.id)
      }.must_differ "OrderItem.count", 1
      cart = Order.first
      
      expect{
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
      
      expect{
        post add_to_cart_path(valid_product1.id)
      }.must_differ "OrderItem.count", 1
      cart = Order.first
      order_item = OrderItem.first
      expect _(order_item.product).must_equal valid_product1
      expect _(order_item.quantity).must_equal 1
      
      expect{
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
      
      expect{
        post add_to_cart_path(product.id)
      }.must_differ "OrderItem.count", 1
      cart = Order.first
      order_item = OrderItem.first
      expect _(order_item.product).must_equal product
      expect _(order_item.quantity).must_equal 1
      
      expect{
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
      expect{
        post add_to_cart_path(no_stock.id)
      }.must_differ "OrderItem.count", 0
      
      must_redirect_to product_path(no_stock.id)
    end
    
    it "redirects back to product show view if given a product that is retired" do
      expect{
        post add_to_cart_path(products(:retired_product).id)
      }.must_differ "OrderItem.count", 0
      
      must_redirect_to product_path(products(:retired_product).id)
    end
    
    it "redirects back to product index view if given an invalid product id" do
      expect{
        post add_to_cart_path(-1)
      }.must_differ "OrderItem.count", 0
      
      must_redirect_to products_path
    end
  end
  
  describe "update action" do
    before do
      @updated_order_item_hash = {
        order_item: {
          quantity: 12
        }
      }
    end
    
    it "redirects back to cart show view if given an invalid order item id" do
      expect{
        patch order_item_path(-1)
      }.must_differ "OrderItem.count", 0
      
      must_redirect_to products_path
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
      
      must_redirect_to order_path
      assert_nil(OrderItem.find_by(id: order_item.id))
    end
    
    it "redirects to order show view and won't affect OrderItem data if given invalid order item id" do
      expect { 
        delete order_item_path(-1) 
      }.must_differ "OrderItem.count", 0
      
      must_redirect_to order_path
    end
  end
end