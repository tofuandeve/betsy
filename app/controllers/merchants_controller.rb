class MerchantsController < ApplicationController
  
  def current
    if session[:merchant_id] == nil
      flash[:error] = "Error! There is no merchant currently logged in."
      redirect_to root_path
      return
    else
      @merchant = Merchant.find_by(id: session[:merchant_id])
      # redirect to a merchant show view so that we can reuse show view template
      redirect_to merchant_path(session[:merchant_id])
      return
    end
  end
  
  def show
    @merchant = Merchant.find_by(id: params[:id])
    if @merchant.nil?
      flash[:error] = "Invalid merchant information."
      redirect_to root_path
      return
    end
    
    if @merchant.id != (session[:merchant_id])
      flash[:error] = "You must log in to view the merchant dashboard."
      redirect_to root_path
      return
    end

    @all_orders = @merchant.orders_by_status
    @completed_orders = @merchant.orders_by_status("complete")
    @pending_orders = @merchant.orders_by_status("pending")
    @cancelled_orders = @merchant.orders_by_status("cancelled")
    @paid_orders = @merchant.orders_by_status("paid")
    
    @all_orders_revenue = @merchant.revenue_by_status
    @completed_orders_revenue = @merchant.revenue_by_status("complete")
    @pending_orders_revenue = @merchant.revenue_by_status("pending")
    @cancelled_orders_revenue = @merchant.revenue_by_status("cancelled")
    @paid_orders_revenue = @merchant.revenue_by_status("paid")
    

  end
  
  def create
    auth_hash = request.env["omniauth.auth"]
    merchant = Merchant.find_by(uid: auth_hash[:uid], provider: "github")
    if merchant
      flash[:status] = :success
      flash[:result_text] = "Successfully logged in as existing merchant #{merchant.username}"
      session[:merchant_id] = merchant.id
    else
      merchant = Merchant.build_from_github(auth_hash)
      if merchant.save
        flash[:status] = :success
        flash[:result_text] = "Successfully created new merchant #{merchant.username} with ID #{merchant.id}"
        session[:merchant_id] = merchant.id
      else
        flash.now[:status] = :failure
        flash.now[:result_text] = "Could not create new account"
        flash.now[:messages] = merchant.errors.messages
        return redirect_to root_path
      end
    end
    
    redirect_to root_path
    return
  end
  
  def destroy
    session[:merchant_id] = nil
    flash[:success] = "Successfully logged out!"
    redirect_to root_path
  end
end
