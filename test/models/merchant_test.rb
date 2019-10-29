require "test_helper"

describe Merchant do
  let(:valid_merchant1) { merchants(:merchant1) }
  let(:valid_merchant2) { merchants(:merchant2) }
  
  
  before do
    @valid_orders = []
    [products(:product1), products(:product2), products(:product3)].each do |product|
      valid_product = Product.create(
        name: product.name,
        status: product.status,
        description: product.description,
        price: product.price,
        stock: product.stock,
        photo_url: product.photo_url,
        merchant_id: valid_merchant1.id 
      )
      
      valid_order = Order.create()
      @valid_orders << valid_order
      
      valid_order_item = OrderItem.new(quantity: 1)
      valid_order_item.product = valid_product
      valid_order_item.order = valid_order
      valid_order_item.save
    end
  end
  
  describe "orders method" do
    it "returns a list of all Order instances" do
      orders = valid_merchant1.orders
      
      expect _(orders.length).must_equal Order.count
      expect(orders).must_be_instance_of Array
      orders.each do |order|
        expect(order).must_be_instance_of Order
      end
    end
    
    it "returns a list of all Order instances by status" do
      ["pending", "paid", "complete", "cancelled"].each do |new_status|
        @valid_orders.each do |order|
          order.update(status: new_status)
        end

        orders = valid_merchant1.orders(status: new_status)
        expect(orders).must_be_instance_of Array

        orders.each do |order_by_status|
          expect(order_by_status).must_be_instance_of Order
          expect _(order_by_status.status).must_equal new_status
        end
      end
    end
    
    it "returns an empty array if merchant doesn't have any order" do
      orders = valid_merchant2.orders
      
      expect(orders).must_be_instance_of Array
      assert(orders.empty?)
    end
  end
end
