require "test_helper"

describe MerchantsController do

  describe "show" do

        it "correctly locates a merchant by username" do
          valid_merchant = Merchant.create(username: "industrious_raccoon", email: "givemeyoureggshells@bandit.com")
          valid_merchant = Merchant.find_by(username: valid_merchant.username)

          get merchants_path(id: valid_merchant.id)
          must_redirect_to merchants_path(id: valid_merchant.id)
        end

        it "redirects to root path when given an invalid id" do
          
          get merchants_path(-1)
          must_redirect_to merchants_path
        end


    end
  end



