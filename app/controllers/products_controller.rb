class ProductsController < ApplicationController
before_action :authenticate_user!, except: [:index, :show] 
# authenticate_user! is found in application_controller 
before_action :set_products, only: [:edit, :update, :show, :destroy]
before_action :authorize!, only: [:edit, :update, :destroy]


  def index
      @products = Product.all
  end
  
  def new 
      @product = Product.new
  end

  def create
      @product = Product.new(product_params)
      @product.user = current_user # product_user is a variable 
      # product.user is a method 
      if @product.save
      flash[:success] = "Product was successfully listed!"
      redirect_to product_path(@product)
      else
      @product.errors
      render 'new'
      end
  end
  
  def show
      @review = Review.new
      @reviews = @product.reviews.order(created_at: :desc)
      if can? :crud, @product
        @reviews = @product.reviews.order(created_at: :desc)
      else
        @reviews = @product.reviews.where(hidden: false).order(created_at: :desc)
      end
  end

  def edit 
  end

  def update
      if @product.update(product_params)
          flash[:success] = "Product was successfully updated!"
          redirect_to product_path(@product)
      else
          render 'edit'
      end
  end

  def destroy
    flash[:danger] = "Product destoryed!"
    @product.destroy
    redirect_to products_path
  
end


  private

  def product_params
      params.require(:product).permit(:title, :description, :price)
  end

  def set_products
      @product = Product.find(params[:id]) #querying a product
  end

  def authorize! 
    flash[:danger] = "Not Authorized!"
    redirect_to root_path unless 
    can?(:crud, @product)
  end 

end
