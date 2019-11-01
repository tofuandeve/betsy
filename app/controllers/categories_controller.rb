class CategoriesController < ApplicationController
  before_action :merchant_nil?

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)

    if @category.save
      flash[:success] = "Successfully created new category."
      redirect_to merchant_path(session[:merchant_id])
    else
      flash.now[:error] = "Invalid entry. Please try again."
      render :new
    end
  end

  private

  def category_params
    return params.require(:category).permit(:name)
    #do we need to include the product_ids?
  end

  def merchant_nil?
    if session[:merchant_id] == nil
      flash[:error] = "Please log in as a merchant to create a category."
      redirect_to root_path
      return
    end
  end
end
