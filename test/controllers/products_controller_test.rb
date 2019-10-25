require "test_helper"

describe ProductsController do
  
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
      valid_garbage = Product.create(name: "trashgarbage", status: "active", description: "nice and slimy, beautiful and rotten", price: 12, stock: 14, photo_url: "http://imgur.com/eggshells4life")
      p valid_garbage = Product.find_by(id: valid_garbage.id)

      get product_path( valid_garbage.id )
      must_respond_with :success
    end

    it "redirects to product index when given an invalid id" do
       get product_path( -1 )
       must_redirect_to products_path
    end
  end

  describe "create" do
    it "creates a new product successfully with valid data" do
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
      p Product.find_by(name: "trashgarbage")
      must_redirect_to product_path(Product.find_by(name: "trashgarbage").id)
    end

    it "redirects to the new product's show page" do
    end

    it "does not create a new product when given invalid information" do
    end

    it "directs to new product path when given invalid information" do
    end
  end

  describe "update" do
    it "successfully changes the parameters given" do
    end

    it "redirects to the correct merchant's page" do
    end

    it "does not change information when given invalid parameters" do
    end

    it "redirects to update path when given invalid parameters" do
    end
  end

end