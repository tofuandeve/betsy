require "test_helper"

describe Order do
  let(:valid_product1) { products(:product1) }
  let(:valid_product2) { products(:product2) }

  describe "relations" do
    before do
      @order = Order.new(
        buyer_email: "mackie@doodles.com",
        buyer_address: "123 Street Rd",
        buyer_name: "Mackie Doo",
        buyer_card: "1111 2222 3333 4444",
        card_expiration: "02/20",
        cvv: "123",
        zipcode: "98103",
      )

      @order.save

      @order_item1 = OrderItem.new(
        quantity: 2,
        product_id: valid_product1.id,
        order_id: @order.id,
      )

      @order_item1.save

      @order_item2 = OrderItem.new(
        quantity: 1,
        product_id: valid_product2.id,
        order_id: @order.id,
      )

      @order_item2.save
    end

    describe "Order Items relation" do
      it "can get the order items through 'order_items'" do
        expect(@order.order_items.length).must_equal 2
        expect(@order.order_items[0]).must_equal @order_item1
        expect(@order.order_items[1]).must_equal @order_item2
      end
    end

    describe "validations upon update" do
      it "indicates a fully filled out order is valid" do
        expect(@order.valid?)
      end
      it "validates there is a buyer_email" do
        order_params = { buyer_email: nil }
        @order.update(order_params)

        refute(@order.valid?)
      end
      it "validates there is a buyer_address" do
        order_params = { buyer_address: nil }
        @order.update(order_params)

        refute(@order.valid?)
      end
      it "validates there is a buyer_name" do
        order_params = { buyer_name: nil }
        @order.update(order_params)

        refute(@order.valid?)
      end
      it "validates there is a buyer_card" do
        order_params = { buyer_card: nil }
        @order.update(order_params)

        refute(@order.valid?)
      end
      it "validates there is a card_expiration" do
        order_params = { card_expiration: nil }
        @order.update(order_params)

        refute(@order.valid?)
      end
      it "validates there is a cvv" do
        order_params = { cvv: nil }
        @order.update(order_params)

        refute(@order.valid?)
      end
      it "validates there is a zipcode" do
        order_params = { zipcode: nil }
        @order.update(order_params)

        refute(@order.valid?)
      end
    end
  end
end
