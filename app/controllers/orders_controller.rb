class OrdersController < ApplicationController
  def new
    @order = Order.new
  end

  def create
    @order = Order.new(order_params)

    if @order.save
      # If the book saves correctly, we will notify the user that it was good using flash, and then redirect them to the book show page
      flash[:success] = "Order #{@order.id} created successfully"
    else
      flash.now[:error] = "You ARE BAD."
    end

    redirect_to order_path(@order.id)
  end

  private

  def order_params
    # The responsibility of this method is to return "strong params"
    # .require is used when we use form_with and a model, and therefore our expected form data has the "book" hash inside of it
    # .permit takes in a list of names of attributes to allow... (aka the new Book form has title, author, description)
    return params.require(:order).permit(:buyer_email, :buyer_address, :buyer_name, :buyer_card, :card_expiration, :cvv, :zipcode, :status)

    # Remember: If you ever update the database, model, and form, this will also need to be updated
  end
end
