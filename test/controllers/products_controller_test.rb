require "test_helper"

describe ProductsController do

  let(:valid_product1) { products( :product1 ) }
  let(:valid_product2) { products( :product2 ) }
  let(:valid_product3) { products( :product3 ) }
  let(:retired_product) { products( :retired_product) }

  describe "logged out user" do

    describe "index" do
      it "responds with success when directed to the index page when logged out" do
        get products_path
        must_respond_with :success
      end
    end

    describe "show" do
      it "responds with success when given id exists when logged out" do

        get product_path( valid_product1.id )
        must_respond_with :success 
      end

      it "redirects to product index when given an invalid id when logged out" do
        get product_path( -1 )
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
        get edit_product_path( valid_product1.id )
        must_redirect_to root_path
      end
    end

    describe "update" do
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

        get product_path( valid_product1.id )
        must_respond_with :success
      end

      it "redirects to product index when given an invalid id when logged in" do
        get product_path( -1 )
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

end