require "test_helper"

describe Merchant do
  let(:valid_merchant1) { merchants(:merchant1) }
  let(:valid_merchant2) { merchants(:merchant2) }
  let(:valid_merchant3) { merchants(:merchant3) }
  
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
      
      valid_order = Order.create(
        buyer_email: "raccon@raccoon.net",
        buyer_address: "123 raccoon way",
        buyer_name: "Rocky Raccoon Jr.",
        buyer_card: "12334577848",
        card_expiration: "12/23",
        cvv: "234",
        zipcode: "98102"
      )
      
      @valid_orders << valid_order
      
      valid_order_item = OrderItem.new(quantity: 1)
      valid_order_item.product = valid_product
      valid_order_item.order = valid_order
      valid_order_item.save
    end

    product = products(:product1)
    @merchant3_product = Product.create(
      name: product.name,
      status: product.status,
      description: product.description,
      price: product.price,
      stock: product.stock,
      photo_url: product.photo_url,
      merchant_id: valid_merchant3.id 
    )
    @merchant3_order = Order.create(
      buyer_email: "raccon@raccoon.net",
      buyer_address: "123 raccoon way",
      buyer_name: "Rocky Raccoon Jr.",
      buyer_card: "12334577848",
      card_expiration: "12/23",
      cvv: "234",
      zipcode: "98102"
    )

    @merchant3_order_item = OrderItem.new(quantity: 1)
    @merchant3_order_item.product = @merchant3_product
    @merchant3_order_item.order = @merchant3_order
    @merchant3_order_item.save
  end
  
  describe "order by status method" do
    it "returns a list of all Order instances for the given merchant and does not return orders belonging to other merchants" do
      orders = valid_merchant1.orders_by_status
      merchant3_orders = valid_merchant3.orders_by_status
      
      expect _(orders.length).must_equal 3
      expect(merchant3_orders.length).must_equal 1
      expect(orders).must_be_instance_of Array
      orders.each do |order|
        expect(order).must_be_instance_of Order
        expect _(order.status).must_equal "pending"
      end
    end
    
    it "returns a list of all Order instances by status" do
      orders = valid_merchant1.orders_by_status
      statuses = ["paid", "complete", "cancelled"]
      
      statuses.length.times do |index|
        new_status = statuses[index]
        orders[index].update(status: new_status)
        
        filtered_orders = valid_merchant1.orders_by_status(new_status)
        
        expect(filtered_orders.length).must_equal 1
        expect(filtered_orders.first.status).must_equal new_status
      end
    end
    
    it "returns an empty array if merchant doesn't have any order" do
      orders = valid_merchant2.orders_by_status
      
      expect(orders).must_be_instance_of Array
      assert(orders.empty?)
    end
  end

  describe "revenue_by_status" do
    it "returns the total revenue when not given a status and the merchant has multiple valid orderitems" do
      expect(valid_merchant1.revenue_by_status).must_equal 142.0
    end

    it "returns 0 when not given a status the merchant doesn't have any products" do
      expect(valid_merchant2.revenue_by_status).must_equal 0
    end

    it "returns the total revenue of all the merchant's orders with the given valid status" do
      @valid_orders.each do |order|
        expect(order.status).must_equal "pending"
      end
      expect(valid_merchant1.revenue_by_status("pending")).must_equal 142
    end

    it "returns 0 if the merchant does not have any orders with the given status" do
      expect(valid_merchant1.revenue_by_status("paid")).must_equal 0
    end
  end

  describe "number_of_orders_by_status" do
    it "returns the total number of the merchant's orders with the given status" do
      @valid_orders.each do |order|
        expect(order.status).must_equal "pending"
      end
      expect(valid_merchant1.number_of_orders_by_status("pending")).must_equal 3
    end

    it "returns 0 if the merchant does not have any orders with the given status" do
      expect(valid_merchant1.number_of_orders_by_status("paid")).must_equal 0
    end
  end
end
