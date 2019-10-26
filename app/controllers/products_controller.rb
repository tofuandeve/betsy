class ProductsController < ApplicationController
  before_action :find_product, only: [:show, :edit, :update]

  def index
    @products = Product.where(status: "active")
  end

  def show
    if @product.nil?
      flash[:error] = "That product does not exist"
      redirect_to products_path
    end
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    @product.status = "active"

    if @product.save
      flash[:success] = "Successfully created #{@product.name}"
      redirect_to product_path( @product.id )
      return
    else
      flash.now[:error] = "A problem occurred: Could not create #{@product.name}"
      render new_product_path
      return
    end
  end

  def edit
  end

  def update
    if @product.update( product_params )
      flash[:success] = "Successfully updated #{@product.name}"
      redirect_to product_path( @product.id )
      return
    else
      flash[:error] = "A problem occurred and #{@product.name} could not be updated."
      render :edit
      return
    end
  end

private

  def find_product
    @product = Product.find_by(id: params[:id])
  end

  def product_params
    return params.require(:product).permit(:name, :status, :description, :price, :stock, :photo_url)
  end

end