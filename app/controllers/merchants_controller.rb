class MerchantsController < ApplicationController

    def show 
        @merchant = Merchant.find_by(id: params[:id])

        if @merchant.nil?
            flash[:error] = "You must log in to view the merchant dashboard."
            redirect_to root_path
            return
        else
            redirect_to merchant_path(@merchant.id)
        end
        
    end
end

