class PostsController < ApplicationController


	def index
		@posts = Post.all
	end

	def new
		@post = Post.new
	end

	def create
		@post = Post.new(post_params)
		if @post.save
			flash[:success] = "Post created"
			redirect_to root_path
		else
			flash[:error] = "Could not create Post"
			render 'new'
		end
	end

	def show
		@post = Post.find(params[:id])
		#@commentable = @post
		@comments = @post.comments
		@comment = Comment.new
	end

	def edit
		@post = Post.find(params[:id])
	end
	def update
		@post = Post.find(params[:id])

		if @post.update(post_params)
			flash[:success] = "Post updated"
			redirect_to root_path
		else
			flash[:error] = "Could not update Post"
			render 'edit'
		end
	end

	def delete
		Post.find([:id]).destroy
		flash[:success] = "Post deleted"
		redirect_to root
	end

	private

	def post_params
		params.require(:post).permit(:title, :content)
	end
end