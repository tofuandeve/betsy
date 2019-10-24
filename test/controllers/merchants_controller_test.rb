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
end
