require "test_helper"

describe Review do
  describe "relations" do
    it "can get the product through 'product" do
      valid_review = reviews(:review1)
      valid_review.product = products(:product1)
      expect(valid_review.product).must_be_instance_of Product
    end
  end
end
