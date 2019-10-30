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
    
    @product = Product.find_by(id: params[:id])
    
    if @product.nil?
      flash[:error] = "Product doesn't exist!"
    elsif !@product.in_stock? 
      flash[:error] = "#{@product.name} is out of stock!"
    else
      @order_item = order.find_order_item_by_product_id(@product.id)
  
      if @product.in_stock?
        if @order_item
          if @order_item.quantity < @product.stock
            @order_item.quantity += 1
          end
        else
          @order_item = OrderItem.new(
            product_id: params[:id], 
            order_id: session[:order_id],
            quantity: 1
          )
        end
        
        if @order_item.save
          flash[:success] = "Item was successfully added to cart!"
        else
          flash[:error] = "Failed to add item to cart!"
        end 
        
      else
        flash[:error] = "There aren't enough items in stock for your order!"
      end
    end
    
    redirect_to request.referrer
    return
  end
  
  def edit
    @order_item = OrderItem.find_by(id: params[:id])
  end
  
  def update
    @order_item = OrderItem.find_by(id: params[:id])
    if session[:order_id] && @order_item && @order_item.order_id == session[:order_id]
      quantity_difference = @order_item.quantity_change(@order_item.order, params[:order_item][:quantity])
      @product = @order_item.product
      
      if @product.update_stock(quantity_difference)
        @order_item.quantity = params[:order_item][:quantity]
        
        if @order_item.save
          flash[:success] = "Item in cart was successfully updated"
        else
          flash[:error] = "Failed to update item in cart!"
        end 
        
      else
        flash[:error] = "There aren't enough items in stock for your order!"
      end  
    end
    
    redirect_to request.referrer
    return
  end
  
  def destroy
    order_item = OrderItem.find_by(id: params[:id])
    if order_item
      order_item.destroy
      flash[:success] = "Item: " + order_item.product.name + " was successfully deleted!"
    end
    
    redirect_to order_path
    return
  end
end