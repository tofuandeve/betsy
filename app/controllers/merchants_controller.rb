class MerchantsController < ApplicationController
  def index
  end

  def create
    auth_hash = request.env["omniauth.auth"]
    merchant = Merchant.find_by(uid: auth_hash[:uid], provider: "github")
    if merchant
      flash[:status] = :success
      flash[:result_text] = "Successfully logged in as existing merchant #{merchant.username}"
    else
      merchant = Merchant.build_from_github(auth_hash)

      if merchant.save
        flash[:status] = :success
        flash[:result_text] = "Successfully created new merchant #{merchant.username} with ID #{merchant.id}"
      else
        flash.now[:status] = :failure
        flash.now[:result_text] = "Could not create new account"
        flash.now[:messages] = merchant.errors.messages
        return redirect_to root_path
      end
    end

    session[:merchant_id] = merchant.id
    redirect_to root_path
    return
  end
end
