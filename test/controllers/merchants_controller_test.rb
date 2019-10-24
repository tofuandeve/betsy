require "test_helper"
require "pry"

describe MerchantsController do
  describe "auth_callback" do
    it "logs in an existing merchant and redirects to the root route" do
      start_count = Merchant.count
      merchant = merchants(:merchant1)
      
      perform_login(merchant)
      must_redirect_to root_path
      session[:merchant_id].must_equal merchant.id
      
      # Should *not* have created a new user
      Merchant.count.must_equal start_count
    end
    
    describe "creates an account for a new user and redirects to the root route" do
      it "creates a new user" do
        start_count = Merchant.count
        merchant = Merchant.new(provider: "github", uid: 99999, username: "test_merchant", email: "test@merchant.com")
        
        OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(mock_auth_hash(merchant))
        get auth_callback_path(:github)
        
        must_redirect_to root_path
        
        # Should have created a new user
        Merchant.count.must_equal start_count + 1
        
        # The new user's ID should be set in the session
        session[:merchant_id].must_equal Merchant.last.id
      end
    end
    
    it "redirects to the login route if given invalid user data" do
      OmniAuth.config.mock_auth[:github] =
      OmniAuth::AuthHash.new(mock_auth_hash(Merchant.new))
      
      expect { get auth_callback_path(:github) }.wont_change "Merchant.count"
      
      must_redirect_to root_path
      expect(session[:merchant_id]).must_be_nil
    end
  end
end
