require "test_helper"

describe MerchantsController do

  describe "show" do

        it "correctly locates a merchant by username" do
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



