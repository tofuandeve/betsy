require "test_helper"

describe MerchantsController do
  describe "auth_callback" do
    it "logs in an existing merchant and redirects to the root route" do
      start_count = Merchant.count
      merchant = merchants(:merchant1)
      
      perform_login(merchant)
      must_redirect_to root_path
      expect _(session[:merchant_id]).must_equal merchant.id
      
      # Should *not* have created a new user
      expect _(Merchant.count).must_equal start_count
    end
    
    it "creates an account for a new user and redirects to the root route" do
      start_count = Merchant.count
      merchant = Merchant.new(provider: "github", uid: 99999, username: "test_merchant", email: "test@merchant.com")
      
      OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(mock_auth_hash(merchant))
      get auth_callback_path(:github)
      
      must_redirect_to root_path
      
      # Should have created a new user
      expect _(Merchant.count).must_equal start_count + 1
      
      # The new user's ID should be set in the session
      expect _(session[:merchant_id]).must_equal Merchant.last.id
    end
    
    
    it "redirects to the login route if given invalid user data" do
      OmniAuth.config.mock_auth[:github] =
      OmniAuth::AuthHash.new(mock_auth_hash(Merchant.new))
      
      expect { get auth_callback_path(:github) }.wont_change "Merchant.count"
      
      must_redirect_to root_path
      assert_nil (session[:merchant_id])
    end
  end
  
  describe "current" do
    it "responds with success when merchant has logged in" do
      # Arrange
      perform_login
      
      # Act
      get current_merchant_path
      
      # Assert
      must_respond_with :success
    end
    
    it "redirects to root path when merchant hasn't logged in" do
      # No arrange needed
      
      # Act
      get current_merchant_path
      
      # Assert
      must_redirect_to root_path
    end
  end
  
  describe "show" do
    
    it "successfully redirects to the show page for a valid merchant" do
      valid_merchant = Merchant.create(uid: 12, provider: "github", username: "industrious_raccoon", email: "givemeyoureggshells@bandit.com")
      valid_merchant = Merchant.find_by(uid: 12, provider: "github")
      
      get merchant_path(valid_merchant.id)
      must_redirect_to merchant_path(valid_merchant.id)
    end
    
    it "redirects to root path when given an invalid id" do
      get merchant_path(-1)
      must_redirect_to root_path
    end
  end
end