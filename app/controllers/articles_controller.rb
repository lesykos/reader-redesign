class ArticlesController < ApplicationController
	before_action :signed_in_user, only: [:new, :create, :edit, :update, :destroy]

	def index
		if params[:category]
			@articles = Article.categorized_with(params[:category])
		elsif params[:author]
			@articles = Article.users_articles(params[:author])
		else			
			@articles = Article.all
		end
	end

	def show
		@article = Article.find(params[:id])
	end

	def new
		@article = Article.new
	end

	def create
		@article = Article.new(article_params)
		@article.user_id = current_user.id
		if @article.save
			flash[:success] = "New article has been created."
			redirect_to @article
		else
			render 'new'
		end
	end

	def edit
		@article = Article.find(params[:id])
	end

	def update
		@article = Article.find(params[:id])
		if @article.update_attributes(article_params)
			redirect_to @article
			flash[:success] = "Article updated"
		else
			render 'edit'
		end
	end

	def destroy
		Article.find(params[:id]).destroy
		flash[:success] = "Article deleted"
		redirect_to articles_url
	end


	private

		def article_params
			params.require(:article).permit(:title, :content, :publish_date, :category_list)
		end

end