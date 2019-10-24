class MerchantsController < ApplicationController
  def current
    @merchant = Merchant.find_by(id: session[:user_id])
    if @merchant.nil?
      head :not_found
      return
    end 
  end
  
end
