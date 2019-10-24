require "test_helper"
require "pry"

describe MerchantsController do
  # describe "auth_callback" do
  #   it "logs in an existing merchant and redirects to the root route" do
  #     start_count = Merchant.count
  #     merchant = merchants(:merchant1)

  #     perform_login(merchant)
  #     must_redirect_to root_path
  #     session[:merchant_id].must_equal merchant.id

  #     # Should *not* have created a new user
  #     Merchant.count.must_equal start_count
  #   end

  #   describe "creates an account for a new user and redirects to the root route" do
  #     it "creates a new user" do
  #       start_count = Merchant.count
  #       merchant = Merchant.new(provider: "github", uid: 99999, username: "test_merchant", email: "test@merchant.com")

  #       OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(mock_auth_hash(merchant))
  #       get auth_callback_path(:github)

  #       must_redirect_to root_path

  #       # Should have created a new user
  #       Merchant.count.must_equal start_count + 1

  #       # The new user's ID should be set in the session
  #       session[:merchant_id].must_equal Merchant.last.id
  #     end
  #   end

  #   it "redirects to the login route if given invalid user data" do
  #   end
  # end

  describe "auth_callback" do
    it "logs in an existing user and redirects them to the root path" do
      # expect {
      #   get auth_callback_path(:github)
      # }.wont_change "Merchant.count"
      # binding.pry
      # get auth_callback_path(:github)
      perform_login
      # post merchants_path

      # must_redirect_to root_path
      expect(session[:merchant_id]).must_equal merchant.id
      # You can test the flash notice too!
    end

    it "logs in a new user and redirects them back to the root path" do
      # user = User.new(name: "Batman", provider: "github", uid: 999, email: "bat@man.com")
      # OmniAuth.config.mock_auth[:github] =
      # OmniAuth::AuthHash.new(mock_auth_hash(user))

      # expect {
      # get auth_callback_path(:github)
      # }.must_differ "User.count", 1

      # user = User.find_by(uid: user.uid)

      # must_redirect_to root_path
      # expect(session[:user_id]).must_equal user.id

      merchant = Merchant.new(username: "Batman", provider: "github", uid: 999, email: "bat@man.com")
      OmniAuth.config.mock_auth[:github] =
        OmniAuth::AuthHash.new(mock_auth_hash(merchant))
      expect {
        get auth_callback_path(:github)
      }.must_differ "Merchant.count", 1

      merchant = Merchant.find_by(uid: merchant.uid)

      must_redirect_to root_path
      expect(session[:merchant_id]).must_equal merchant.id
      # You can test the flash notice too!
    end

    it "should redirect back to root for invalid callbacks" do
      OmniAuth.config.mock_auth[:github] =
        OmniAuth::AuthHash.new(mock_auth_hash(Merchant.new))

      expect { get auth_callback_path(:github) }.wont_change "Merchant.count"

      must_redirect_to root_path
      expect(session[:merchant_id]).must_be_nil
    end
  end
end
