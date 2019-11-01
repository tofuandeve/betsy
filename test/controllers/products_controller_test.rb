require "test_helper"

describe ProductsController do
  let(:valid_product1) { products(:product1) }
  let(:valid_product2) { products(:product2) }
  let(:valid_product3) { products(:product3) }
  let(:retired_product) { products(:retired_product) }
  
  describe "logged out user" do
    describe "index" do
      it "responds with success when directed to the index page when logged out" do
        get products_path
        must_respond_with :success
      end
      
      it "responds with success when directed to the products by category page with a valid category id" do
        category = categories(:Category1)
        get category_products_path(category.id)
        
        must_respond_with :success
      end
      
      it "redirects to root path when directed to the products by category page with an invalid category id" do
        get category_products_path(-1)
        must_redirect_to root_path
      end

      it "responds with success when directed to the products by merchant page with a valid merchant id" do
        merchant = merchants(:merchant1)
        get merchant_products_path(merchant.id)
        
        must_respond_with :success
      end
      
      it "redirects to root path when directed to the products by merchant page with an invalid merchant id" do
        get merchant_products_path(-1)
        must_redirect_to root_path
      end
    end
    
    describe "show" do
      it "responds with success when given id exists when logged out" do
        get product_path(valid_product1.id)
        must_respond_with :success
      end
      
      it "redirects to product index when given an invalid id when logged out" do
        get product_path(-1)
        must_redirect_to products_path
      end
    end
    
    describe "new" do
      it "redirects to the homepage when a logged out user tries to create a new product" do
        get new_product_path
        must_redirect_to root_path
      end
    end
    
    describe "create" do
      it "redirects to the homepage when a logged out user tries to create a new product" do
        post products_path
        must_redirect_to root_path
      end
    end
    
    describe "edit" do
      it "redirects to the homepage when a logged out user tries to edit a product" do
        get edit_product_path(valid_product1.id)
        must_redirect_to root_path
      end
    end
    
    describe "update" do
      it "redirects to the homepage when a logged out user tries to update a product" do
        patch product_path(valid_product1.id)
        must_redirect_to root_path
      end
    end
  end
  
  describe "logged in user" do
    before do
      perform_login
    end
    
    describe "index" do
      it "responds with success when directed to the index page when logged in" do
        get products_path
        must_respond_with :success
      end
    end
    
    describe "show" do
      it "responds with success when given id exists when logged in" do
        get product_path(valid_product1.id)
        must_respond_with :success
      end
      
      it "redirects to product index when given an invalid id when logged in" do
        get product_path(-1)
        must_redirect_to products_path
      end
    end
    
    describe "new" do
      it "responds with success when directed to the new product form as a logged in user" do
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
            category_ids: "1",
            price: 12,
            stock: 14,
            photo_url: "https://imgur.com/eggshells4life",
            merchant_id: session[:merchant_id],
          },
        }
        expect { post products_path, params: product_hash }.must_differ "Product.count", 1
        must_redirect_to product_path(Product.find_by(name: "trashgarbage").id)
      end
      
      it "does not create a new product when given invalid information and renders to new product path" do
        product_hash = {
          product: {
            name: "",
            status: "active",
            description: "nice and slimy, beautiful and rotten",
            category_ids: "1, 2",
            price: 12,
            stock: 14,
            photo_url: "https://imgur.com/eggshells4life",
            merchant_id: session[:merchant_id],
          },
        }
        
        expect { post products_path, params: product_hash }.must_differ "Product.count", 0
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
          product: {
            name: "smashed pumpkin with face nibbles",
            status: "active",
            description: "work of art",
            category_ids: "2",
            price: 50,
            stock: 1,
            photo_url: "https://imgur.com/pumpkinbits",
            merchant_id: session[:merchant_id],
          },
        }
        
        @invalid_product = {
          product: {
            name: "",
            status: "active",
            description: "nice and slimy, beautiful and rotten",
            category_ids: "2",
            price: 12,
            stock: 14,
            photo_url: "https://imgur.com/eggshells4life",
            merchant_id: session[:merchant_id],
          },
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

    describe "retire" do
      before do
        @product = Product.create(
          name: "smashed pumpkin with face nibbles",
          status: "active",
          description: "work of art",
          price: 50,
          stock: 1,
          photo_url: "https://imgur.com/pumpkinbits",
          merchant_id: session[:merchant_id],
        )
      end

      it "successfully retires a merchant's product and redirects when a logged in merchant retires their own product" do
        expect _(@product.status).must_equal "active"

        patch retire_path(@product.id)

        product = Product.find_by(id: @product.id)

        expect _(product.status).must_equal "retired" 
        must_redirect_to product_path(@product.id)
      end

      it "does not update a product's status and redirects to the home when a merchant tries to retire another merchant's product" do
        expect _(valid_product3.status).must_equal "active"
        
        patch retire_path(valid_product3.id)

        new_product = Product.find_by(id: valid_product3.id)

        expect _(new_product.status).must_equal "active" 
        must_redirect_to product_path(valid_product3.id)
      end
    end
  end
end
