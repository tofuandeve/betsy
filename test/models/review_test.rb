require "test_helper"

describe Review do
  describe "relations" do
    it "has a product" do
      r = reviews(:review1)
      r.must_respond_to :product

      # need help on this test!
      # r.(Product.find_by(id: @product.id)).must_be_kind_of Product

    end
  end

  # describe "validations" do
  #   let (:product1) { Work.new(category: "book", title: "House of Leaves") }
  #   let (:product2) { Work.new(category: "book", title: "For Whom the Bell Tolls") }

  #   it "allows one user to vote for multiple works" do
  #     vote1 = Vote.new(user: user1, work: work1)
  #     vote1.save!
  #     vote2 = Vote.new(user: user1, work: work2)
  #     vote2.valid?.must_equal true
  #   end

  #   it "allows multiple users to vote for a work" do
  #     vote1 = Vote.new(user: user1, work: work1)
  #     vote1.save!
  #     vote2 = Vote.new(user: user2, work: work1)
  #     vote2.valid?.must_equal true
  #   end

  #   it "doesn't allow the same user to vote for the same work twice" do
  #     vote1 = Vote.new(user: user1, work: work1)
  #     vote1.save!
  #     vote2 = Vote.new(user: user1, work: work1)
  #     vote2.valid?.must_equal false
  #     vote2.errors.messages.must_include :user
  #   end
  # end
end
