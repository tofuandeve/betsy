require "test_helper"

describe MerchantsController do

  describe "current" do
    it "responds with success when user has logged in" do
      # Arrange
      perform_login

      # Act
      get current_merchant_path

      # Assert
      must_respond_with :success
    end

    it "responds with not_found when user hasn't logged in" do
      # No arrange needed

      # Act
      get current_merchant_path

      # Assert
      must_respond_with :not_found
    end
  end

  describe "show" do

    it "successfully redirects to the show page for a valid merchant" do
      valid_merchant = Merchant.create(username: "industrious_raccoon", email: "givemeyoureggshells@bandit.com")

      get merchant_path(valid_merchant.id)
      must_redirect_to merchant_path(valid_merchant.id)
    end

    it "redirects to root path when given an invalid id" do
      get merchant_path(-1)
      must_redirect_to root_path
    end
  end
end



