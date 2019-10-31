class ProductsController < ApplicationController
  before_action :find_product, only: [:show, :edit, :update]
  
  def index
    if params[:category_id]
      @category = Category.find_by(id: params[:category_id])
      if @category.nil?
        flash[:error] = "Invalid category!"
        redirect_to root_path
        return
      end
      @products = Product.list_active.select {|product| product.categories.include?(@category)}
    else
      @products = Product.list_active
    end
  end
  
  def show
    if @product.nil?
      flash[:error] = "That product does not exist"
      redirect_to products_path
    end
  end
  
  def new
    if session[:merchant_id] == nil
      flash[:error] = "You must be logged in to create a new product"
      redirect_to root_path
      return
    else
      @product = Product.new
    end
  end
  
  def create
    if session[:merchant_id] == nil
      redirect_to root_path
      return
    else
      @product = Product.new(product_params)
      @product.merchant = Merchant.find_by(id: session[:merchant_id])
      @product.status = "active"
      @product.photo_url = "https://cdn.mos.cms.futurecdn.net/YYH9o4wmSXJfvbzRTq5BTY-1024-80.jpg" if @product.photo_url.empty?
      if @product.save
        flash[:success] = "Successfully created #{@product.name}"
        redirect_to product_path(@product.id)
        return
      else
        flash.now[:error] = "A problem occurred: Could not create #{@product.name}"
        render new_product_path
        return
      end
    end
  end
  
  def edit
    if session[:merchant_id] == nil
      redirect_to root_path
      return
    end
  end
  
  def update
    if session[:merchant_id] == nil
      redirect_to root_path
      return
    else
      if @product.update(product_params)
        @product.update_attrributes(photo_url: "https://cdn.mos.cms.futurecdn.net/YYH9o4wmSXJfvbzRTq5BTY-1024-80.jpg") if @product.photo_url.empty?
        flash[:success] = "Successfully updated #{@product.name}"
        redirect_to product_path(@product.id)
        return
      else
        flash[:error] = "A problem occurred and #{@product.name} could not be updated."
        render :edit
        return
      end
    end
  end
  
  private
  
  def find_product
    @product = Product.find_by(id: params[:id])
  end
  
  def product_params
    return params.require(:product).permit(:name, :status, :description, :price, :stock, :photo_url, :merchant_id, category_ids: [])
  end
end
