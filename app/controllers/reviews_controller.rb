
class ReviewsController < ApplicationController
  before_action :find_product

  def new
    if session[:merchant_id] == @product.merchant_id
      flash[:error] = "You cannot review your own product"
      redirect_to products_path
    end
    @review = Review.new
  end

  def create
    if @product == nil
      flash.now[:error] = "Could not find selected product to review."
      redirect_to products_path
      return
    elsif session[:merchant_id] == @product.merchant_id
      flash[:error] = "You cannot review your own product"
      redirect_to products_path
    else
      @review = Review.new(review_params)
      @review.product = @product
      if @review.save
        flash[:success] = "Review Successfully Posted"
        redirect_to products_path
        return
      else
        flash.now[:error] = "Invalid review entry. Please try again."
        render :new
        return
      end
    end
  end

  private

  def review_params
    return params.require(:review).permit(:rating, :comment)
  end

  def find_product
    @product = Product.find_by(id: params[:product_id])
  end
end
