class MerchantsController < ApplicationController

    def show 
        @merchant = Merchant.find_by(id: params[:username])

        if @user.nil?
            flash[:error] = "That user does not exist"
            redirect_to homepages_path
            return
        end

        if session[:username].nil?
            flash[:error] = "You must log in to view the merchant dashboard."
            redirect_to homepages_path
            return
        else
            redirect_to merchant_path(id: merchant.id)
        end
        
    end
end

