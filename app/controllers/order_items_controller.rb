class OrderItemsController < ApplicationController
  
  def new
    @order_item = OrderItem.new
  end
  
  def create
    if session[:order_id] == nil
      order = Order.create
      session[:order_id] = order.id
    else
      order = Order.find_by(id: session[:order_id])
    end
    
    @product = Product.find_by(:id params[:order_item][:product_id])
    
    if @product.nil?
      flash[:error] = "Product doesn't exist!"
    elsif !@product.in_stock? 
      flash[:error] = "#{@product.name} is out of stock!"
    elsif @product.decrease_stock(params[:order_item][:quantity])
      # find and replace the current item in cart with the new one
      @order_item = OrderItem.new(order_item_params)

      if @order_item.save && @product.save
        flash[:success] = "Item was successfully added to cart!"
      else
        flash[:error] = "Failed to add item to cart!"
      end 
    else
      flash[:error] = "There aren't enough items in stock for your order!"
    end

    redirect_to request.referrer
    return
  end
  
  def edit
  end
  
  def update
  end
  
  def destroy
  end
end