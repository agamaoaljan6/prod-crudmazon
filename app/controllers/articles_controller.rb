class ArticlesController < ApplicationController
    before_action :find_article, only: [:edit, :update]
    before_action :authenticate_user!, only: [:new, :create, :edit]
    def new
        @article = Article.new
    end 

    def create 
        @article = Article.new params.require(:article).permit(:title, :description)
        @article.user = current_user
        if @article.save
            redirect_to article_path(@article) # @article = id of the article 
        else
            render :new
        end
    end

    def show
        @article = Article.find(params[:id])
    end 

    def index
        @articles = Article.all
    end
    
    def destroy
        article = Article.find params[:id]
        article.destroy
        redirect_to articles_path
    end 
    
    def edit 
    
    end 


    def update
        if @article.update params.require(:article).permit(:title, :description, :published_at)
            redirect_to @article
        else
            render :edit
        end
    end


    private 
    def find_article
    @article = Article.find(params[:id])
    end
end
