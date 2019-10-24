class MerchantsController < ApplicationController
  def index
  end

  def create
    binding.pry
    auth_hash = request.env["omniauth.auth"]
    # raise
    merchant = Merchant.find_by(uid: auth_hash[:uid], provider: "github")
    if merchant
      # User was found in the database
      # session[:merchant_id] = merchant.id
      flash[:status] = :success
      flash[:result_text] = "Successfully logged in as existing merchant #{merchant.username}"
    else
      # User doesn't match anything in the DB
      # Attempt to create a new merchant
      merchant = Merchant.build_from_github(auth_hash)

      if merchant.save
        # session[:merchant_id] = merchant.id
        flash[:status] = :success
        flash[:result_text] = "Successfully created new merchant #{merchant.username} with ID #{merchant.id}"
      else

        # Couldn't save the merchant for some reason. If we
        # hit this it probably means there's a bug with the
        # way we've configured GitHub. Our strategy will
        # be to display error messages to make future
        # debugging easier.
        flash.now[:status] = :failure
        flash.now[:result_text] = "Could not create new account"
        flash.now[:messages] = merchant.errors.messages
        # return redirect_to root_path
      end
    end

    # If we get here, we have a valid merchant instance
    session[:merchant_id] = merchant.id
    redirect_to root_path
    return
  end
end
