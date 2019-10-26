require "test_helper"

describe ProductsController do

  let(:valid_product1) { products( :product1 ) }
  let(:valid_product3) { products( :product3 ) }

  describe "index" do
    it "responds with success when directed to the index page" do
      get products_path
      must_respond_with :success
    end

    it "does not list a product with a retired status" do
      get products_path
      @products.each do |product|
        expect _(product.status).must_equal "active" 
      end
    end

  end

  describe "show" do
    it "responds with success when given id exists" do

      get product_path( valid_product1.id )
      must_respond_with :success
    end

    it "redirects to product index when given an invalid id" do
       get product_path( -1 )
       must_redirect_to products_path
    end
  end

  describe "new" do
    it "responds with success when directed to the new product form" do
      get new_product_path

      must_respond_with :success
    end
  end

  describe "create" do
    it "creates a new product successfully with valid data and redirects to show page for that new product" do
      product_hash = {
        product: {
          name: "trashgarbage",
          status: "active",
          description: "nice and slimy, beautiful and rotten", 
          price: 12,
          stock: 14,
          photo_url: "http://imgur.com/eggshells4life"
        }
      }
      expect { post products_path, params: product_hash }.must_differ 'Product.count', 1
      must_redirect_to product_path(Product.find_by(name: "trashgarbage").id)
    end

    it "does not create a new product when given invalid information and redirects to new product path" do
      product_hash = {
        product: {
          name: "",
          status: "active",
          description: "nice and slimy, beautiful and rotten", 
          price: 12,
          stock: 14,
          photo_url: "http://imgur.com/eggshells4life"
      }
    }

      expect { post products_path, params: product_hash }.must_differ 'Product.count', 0
      must_respond_with :success
    end

  end

  describe "edit" do
    it "responds with success when directed to the edit product form" do
      get edit_product_path(valid_product1.id)

      must_respond_with :success
    end
  end

  describe "update" do

    before do
      @product = {
        product:
          {
            name: "regular pumpkin with nibbles on top",
            status: "active",
            description: "work of art", 
            price: 50,
            stock: 1,
            photo_url: "http://imgur.com/pumpkinbits"
          }
        }

      @invalid_product = {
        product: {
          name: "",
          status: "active",
          description: "nice and slimy, beautiful and rotten", 
          price: 12,
          stock: 14,
          photo_url: "http://imgur.com/eggshells4life"
      }
    }
    end

    it "successfully updates with the parameters given and redirects to the correct product details page" do
      expect { patch product_path(valid_product3.id), params: @product }.must_differ "Product.count", 0
      
      current_product = Product.find_by(id: valid_product3.id)
      
      expect(current_product.name).must_equal @product[:product][:name]
      expect(current_product.price).must_equal @product[:product][:price]

      must_redirect_to product_path(current_product.id)
    end

    it "does not update successfully when given invalid parameters" do
      expect { patch product_path(valid_product3.id), params: @invalid_product }.must_differ "Product.count", 0
      current_product = Product.find_by(id: valid_product3.id)
      
      expect(current_product.name).must_equal valid_product3.name
      expect(current_product.price).must_equal valid_product3.price

      must_respond_with :success
    end
  end

end