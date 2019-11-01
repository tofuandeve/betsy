class OrdersController < ApplicationController
  before_action :find_order, only: [:edit, :update, :cancel, :confirmation, :buyer_info]
  
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
  end
  
  def update
    if @order     
      
      if @order.update(order_params) # update certain attributes instead of everything at once
        flash[:success] = "order updated!"
        redirect_to edit_order_path(@order.id)
        return
      end
      flash.now[:error] = "Required fields cannot be blank!"
      render :edit
      return
    end
  end
  
  def place_order
    if session[:order_id]
      @order = Order.find_by(id: session[:order_id])
      successful = @order.checkout
      
      if successful
        @order.update(status: 'paid')
        flash[:success] = "Successfully placed order! Thanks for shopping with us!"
      else
        flash[:error] = "Failed to place order!"
      end
      
      session[:order_id] = nil
    else
      flash[:error] = "Your cart is empty!"
    end
    
    redirect_to root_path
    return
  end
  
  def cancel
    @order.change_status("cancelled")
    @order.save
  end
  
  def destroy
    order = Order.find_by(id: params[:id])
    if order 
      flash[:success] = "Order deleted!"
      order.destroy
    else
      flash[:error] = "That order doesn't exist!"
    end
    
    redirect_to root_path
    return
  end
  
  def buyer_info
    @username = @order.buyer_name
    @email = @order.buyer_email
    @mailing_address = @order.buyer_address
    @four_digits = @order.buyer_card[-4..-1]
    @cc_exp = @order.card_expiration
  end

  def confirmation

    @quantities = []
    @subtotals = []
    @products = []
    
    @total_number_items = @order.order_items.length

    @order.order_items.each do |item|
      @quantities << item.quantity
      @subtotals << item.item_subtotal
      @products << item.product
    end
    @total_price = @subtotals.sum
    @date_placed = @order.created_at
    @status = @order.status
  end


  private
  
  def order_params
    return params.require(:order).permit(:buyer_email, :buyer_address, :buyer_name, :buyer_card, :card_expiration, :cvv, :zipcode, :status)
  end
  
  def find_order
    @order = Order.find_by(id: params[:id])
    if @order.nil?
      flash[:error] = "That order does not exist"
      redirect_to root_path
    end
  end
end
