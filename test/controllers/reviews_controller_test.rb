require "test_helper"

describe ReviewsController do
  let(:merchant1) { merchants(:merchant1) }
  let(:valid_product1) { products(:product1) }
  let(:valid_product2) { products(:product2) }
  let(:valid_product3) { products(:product3) }
  let(:valid_review) { reviews(:review1) }

  describe "new" do
    it "does not allow for a logged-in merchant to view the new form of their own product and redirects" do
      @valid_product = products(:product1)
      @test_merchant = merchants(:merchant1)
      perform_login(@test_merchant)
      # @category = categories(:Category1)

      # new_product_hash = {
      #   name: "sloppy sandwich",
      #   status: "active",
      #   description: "nice and slimy, beautiful and rotten",
      #   category_ids: ["#{@category.id}"],
      #   price: 12,
      #   stock: 14,
      #   photo_url: "http://imgur.com/eggshells4life",
      #   merchant_id: @test_merchant.id,
      # }
      # review_hash = {
      #   review: {
      #     rating: 4,
      #     description: "kinda neat",
      #   },
      # }

      # expect(@valid_product.reviews.count).must_equal 0
      # new_product = Product.create(new_product_hash)

      get new_product_review_path(@valid_product.id)

      expect(@valid_product.reviews.count).must_equal 0
      must_redirect_to products_path
    end
  end

  describe "guest users review" do
    describe "create" do
      it "creates a new review for an existing item and redirects to the product index page" do
        product_id = valid_product1.id
        review_hash = {
          review: {
            rating: 4,
            comment: "kinda neat",
          },
        }
        expect (valid_product1.reviews.count).must_equal 0

        expect {
          post product_reviews_path(product_id), params: review_hash
        }.must_differ "Review.count", 1

        expect (valid_product1.reviews.count).must_equal 1

        must_redirect_to products_path
      end

      it "does not create a new review for a non-existent item and redirects to the products index page" do
        review_hash = {
          review: {
            rating: 4,
            comment: "kinda neat",
          },
        }

        expect {
          post product_reviews_path(-1), params: review_hash
        }.must_differ "Review.count", 0

        must_redirect_to products_path
      end
    end
  end

  describe "Logged in merchants" do
    describe "create" do
      before do
        @category = categories(:Category1)
        @test_merchant = merchants(:merchant1)
        perform_login(@test_merchant)
        @valid_product = products(:product1)
      end
      let(:review_hash) {
        {
          review: {
            rating: 4,
            description: "was nice and soggy",
          },
        }
      }

      it "allows a merchant to create a review for products that aren't their own" do
        @valid_product2 = products(:product2)
        expect(@valid_product2.reviews.count).must_equal 0

        expect {
          post product_reviews_path(@valid_product2.id), params: review_hash
        }.must_differ "Review.count", 1

        expect(@valid_product2.reviews.count).must_equal 1

        must_redirect_to products_path
      end

      it "does not allow a merchant to create a review for their own products" do
        new_product_hash = {
          name: "sloppy sandwich",
          status: "active",
          description: "nice and slimy, beautiful and rotten",
          category_ids: ["#{@category.id}"],
          price: 12,
          stock: 14,
          photo_url: "https://imgur.com/eggshells4life",
          merchant_id: @test_merchant.id,
        }
        review_hash = {
          review: {
            rating: 4,
            description: "kinda neat",
          },
        }

        expect(@valid_product.reviews.count).must_equal 0
        new_product = Product.create(new_product_hash)
        expect {
          post product_reviews_path(new_product.id), params: review_hash
        }.must_differ "Review.count", 0

        expect(@valid_product.reviews.count).must_equal 0

        must_redirect_to products_path
      end

      it "does not allow a merchant to create a review for a product that doesn't exist" do
        review_hash = {
          review: {
            rating: 4,
            description: "kinda neat",
          },
        }

        expect(@valid_product.reviews.count).must_equal 0

        expect {
          post product_reviews_path(-1), params: review_hash
        }.must_differ "Review.count", 0

        expect(@valid_product.reviews.count).must_equal 0

        must_redirect_to products_path
      end
    end
  end
end
