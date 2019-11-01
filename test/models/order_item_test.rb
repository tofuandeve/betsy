require "test_helper"

describe OrderItem do
  describe "Validations" do
    let(:valid_merchant1) { merchants(:merchant1) }
    let(:valid_merchant2) { merchants(:merchant2) }
    let(:valid_product1) { products(:product1) }
    let(:valid_product2) { products(:product2) }

    before do
      @product = products(:product1)
      @valid_product = Product.create(
        name: @product.name,
        status: @product.status,
        description: @product.description,
        price: @product.price,
        stock: @product.stock,
        photo_url: @product.photo_url,
        merchant_id: valid_merchant1.id,
      )

      @valid_order = Order.create(
        buyer_email: "raccon@raccoon.net",
        buyer_address: "123 raccoon way",
        buyer_name: "Rocky Raccoon Jr.",
        buyer_card: "12334577848",
        card_expiration: "12/23",
        cvv: "234",
        zipcode: "98102",
      )

      @valid_order_item = OrderItem.new(quantity: 3)
      @valid_order_item.product = @valid_product
      @valid_order_item.order = @valid_order
      @valid_order_item.save
    end
    describe "Order_Item relation" do
      it "can get the product through 'product" do
        expect(@valid_order_item.product).must_equal @valid_product
      end
      it "can get the order through 'order'" do
        expect(@valid_order_item.order).must_equal @valid_order
      end
    end
    describe "Model Validation" do
      it "is a valid order_item with a postive numeric quantity" do
        @valid_order_item.quantity = 2
        expect(@valid_order_item.valid?)
      end

      it "is an an invalid order_item with no quantity" do
        @valid_order_item.quantity = nil
        refute(@valid_order_item.valid?)
      end

      it "is an an invalid order_item with a non-integer quantity" do
        @valid_order_item.quantity = nil
        refute(@valid_order_item.valid?)
      end

      it "is an an invalid order_item with a quantity less than or equal to zero" do
        @valid_order_item.quantity = -1
        refute(@valid_order_item.valid?)
      end
    end
  end

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
        merchant_id: valid_merchant1.id,
      )

      valid_order = Order.create(
        buyer_email: "raccon@raccoon.net",
        buyer_address: "123 raccoon way",
        buyer_name: "Rocky Raccoon Jr.",
        buyer_card: "12334577848",
        card_expiration: "12/23",
        cvv: "234",
        zipcode: "98102",
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
      refute(@valid_order_item.product.valid?)
    end

    it "returns 0 when the product price is not a number" do
      @valid_order_item.product.price = "abc"
      refute(@valid_order_item.product.valid?)
    end
  end

  describe "toggle_shipped" do
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
        merchant_id: valid_merchant1.id,
      )

      valid_order = Order.create(
        buyer_email: "raccon@raccoon.net",
        buyer_address: "123 raccoon way",
        buyer_name: "Rocky Raccoon Jr.",
        buyer_card: "12334577848",
        card_expiration: "12/23",
        cvv: "234",
        zipcode: "98102",
      )

      @valid_order_item = OrderItem.new(quantity: 3)
      @valid_order_item.product = valid_product
      @valid_order_item.order = valid_order
      @valid_order_item.save
    end
    it "changes the order_item's status to shipped if it was previously not_shipped" do
      expect(@valid_order_item.shipped_status).must_equal "not_shipped"
      @valid_order_item.toggle_shipped
      expect(@valid_order_item.shipped_status).must_equal "shipped"
    end

    it "changes the product's status to active if it was previously retired" do
      @valid_order_item.toggle_shipped
      expect(@valid_order_item.shipped_status).must_equal "shipped"
      @valid_order_item.toggle_shipped
      expect(@valid_order_item.shipped_status).must_equal "not_shipped"
    end
  end
end
