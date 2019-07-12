class ReviewsController < ApplicationController
    before_action :authenticate_user!
    before_action :find_review, only: [:destroy, :toggle_hidden]
    before_action :authorize!, only: [:edit, :update, :destroy]
    before_action :authorize_toggle!, only: [:toggle_hidden]
    def create
        @product = Product.find(params[:product_id]) #query the product id (looking for the id of the product)        
        @review = Review.new review_params
        # this is creating a new review and review_params is a private method 
        # that's requiring the review and permits the body and rating of the review
        @review.product = @product # setting the id of the review to the product
        @review.user = current_user
        # so the ifelse statement is saying the if the review has been save, 
        # redirect to the product_path (which is the show.html.erb file)
        # else render the product_path (which is the show.html.erb file)
        if @review.save #saving the review 
            redirect_to product_path(@product) #this is the showpage for product show.html.erb
        else
            @reviews = @product.reviews.order(created_at: :desc)
            render 'products/show'
        end
    end 
    
    def toggle_hidden
        # update the boolean field 'hidden' to whatever it isn't currently
        @review.update(hidden: !@review.hidden?)
        redirect_to product_path(@review.product), notice: "Review #{@review.hidden ? 'hidden' : 'shown'}."
    end

    def destroy
        @review = Review.find(params[:id])
        @review.destroy
        redirect_to product_path(@review.product)
    end
    

    private 
    
    def review_params
        params.require(:review).permit(:body, :rating)
    end
    def find_review
        @review = Review.find params[:id]
    end

    def authorize!
        redirect_to root_path, alert: "access denied" unless can? :crud, @review
    end

    def authorize_toggle!
        redirect_to root_path, alert: "access denied" unless can? :crud, @review.product
    end
    
end
