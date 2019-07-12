require 'rails_helper'

RSpec.describe ArticlesController, type: :controller do
    def current_user
        @current_user ||= FactoryBot.create(:user)
    end
    
describe "#index" do 
    it "assigns @articles to all created articles (sorted_by created_at)" do  #rename
        article_1 = FactoryBot.create(:article)
        article_2 = FactoryBot.create(:article)
        get :index
        expect(assigns(:articles)).to eq([article_1, article_2]) # :articles should be the same in index method
    end

    it "renders index template" do 
    get :index 
    expect(response).to render_template :index
    end
end

describe "#new" do

    context "without signed in user" do
        it "should redirect to sign in page" do
            get :new
            expect(response).to redirect_to new_session_path
        end
    end

    context "with signed in user" do
        before do
            session[:user_id] = current_user.id
        end
        it "renders a new template" do
            get :new
            expect(response).to render_template :new
        end
        
        it "sets an instance variable with a new JobPost" do
            get :new
            expect(assigns(:article)).to(be_a_new(Article))
        end
    end
    
end

describe '#create' do
    def valid_request
        post :create, params: {
          article: FactoryBot.attributes_for(:article)
        }
    end

    context 'with no user signed in' do
      it 'redirects to the sign in page' do
        valid_request
        expect(response).to redirect_to new_session_path
      end
    end
    
    context 'with user signed in do' do
    before do
        session[:user_id] = current_user.id
    end


    context 'with valid parameters' do

        it 'create a new news article in the db' do
          count_before = Article.count
          valid_request
          count_after = Article.count
          expect(count_after).to eq(count_before + 1)
        end

        it 'redirects to the show page of that news article' do
          valid_request
          expect(response).to redirect_to(article_path(Article.last))
        end
    end

      context 'with invalid parameters' do
        def invalid_request
          post :create, params: {
            article: FactoryBot.attributes_for(:article, title: nil)
          }
        end

        it "doesn't create a news article in the database" do
          count_before = Article.count
          invalid_request
          count_after = Article.count
          expect(count_after).to eq(count_before)
        end

        it "renders the new template" do
          invalid_request
          expect(response).to render_template(:new)
        end
      end
    end
  end


describe "#show" do 
    it "assigns article to @article" do
        article = FactoryBot.create(:article)
        get :show, params: {id: article.id }
        expect(assigns(:article)).to eq(article)
    end
    it "renders show view" do
        article = FactoryBot.create(:article)
        get :show, params: {id: article.id}
        expect(response).to render_template :show  
    end
end


describe "#destroy" do
    it "destroys articles in the database" do
        article = FactoryBot.create(:article)
        delete :destroy, params: {id: article.id }
        expect(Article.find_by(id: article.id)).to be(nil)
    end
    it "redirects to index" do 
        article = FactoryBot.create(:article)
        delete :destroy, params: {id: article.id }
        expect(response).to redirect_to(articles_path)
    end
end

describe "#update" do
    before  do 
        @article = FactoryBot.create(:article)
        # session[:user_id] = current_user.id
    end   

    context "if user not signed in" do
        it 'redirects the user to the sign up page' do
        get :new
        post :create, params: {
            article: FactoryBot.attributes_for(:article)
          }
          expect(response).to redirect_to new_session_path 
        end
    end
    
    context "valid attributes" do
        it "updates the news article record with new attributes" do
            new_title = "#{@article.title} Plus Changes!"
            patch :update, params: {id: @article.id, article: {title: new_title}}
            expect(@article.reload.title).to eq(new_title)
        end
        it "redirect to the news article show page" do
            new_title = "#{@article.title} plus changes!"
            patch :update, params: {id: @article.id, article: {title: new_title}}
            expect(response).to redirect_to(@article)
        end

    end
      

end 

describe "#edit" do
    before  do 
        @article = FactoryBot.create(:article)
        # session[:user_id] = current_user.id
    end  
    context "if user not signed in" do
        it 'redirects to sign in page' do
        get :edit, params: { id: @article.id }
        # post :create, params: {
        #     article: FactoryBot.attributes_for(:article)
        #   } 
        expect(response).to redirect_to new_session_path   
        end
    end

    context "with user signed in" do
        context "with authorized user" do
  
          before do
            request.session[:user_id] = current_user.id
            get :edit, params: { id: @article.id }
          end
  
          it "renders the edit template" do
            get :edit, params: { id: @article.id }
            expect(response).to render_template :edit
          end
      
          it "sets an instance variable based on the article id that is passed" do
            get :edit, params: { id: @article.id }
            expect(assigns(:article)).to eq(@article)
          end
        end
    end
      
    context "with unauthorized user" do
        before do
          get :edit, params: { id: @article.id }
        end

        it "redirects to the new session path path" do
          expect(response).to redirect_to new_session_path
        end
    end
end  

end
