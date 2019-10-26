class OrdersController < ApplicationController
  def new
    @order = Order.new
  end
  
  def create
    @order = Order.new(order_params)
    
    if @order.save
      flash[:success] = "Order #{@order.id} created successfully"
    else
      flash.now[:error] = "You ARE BAD."
    end
    
    redirect_to order_path(@order.id)
  end
  
  def edit
    @order = Order.find_by(id: params[:id])
    if @order.nil?
      redirect_to orders_path
      return
    end
  end
  
  private
  
  def order_params
    return params.require(:order).permit(:buyer_email, :buyer_address, :buyer_name, :buyer_card, :card_expiration, :cvv, :zipcode, :status)
  end
end
