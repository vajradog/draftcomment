class CommentsController < ApplicationController

  def index
    @post = Post.find(params[:post_id])
    @comments = @post.comments.all
  end
  
  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.new(comment_params)
    @comment.status = "draft"
    if @comment.save
      redirect_to post_path(@post), notice: "Thank you. Your comment was created and is awaiting moderation. Once approved it will appear on this page momentarily."
    else
      render :new
    end
  end

  def approve
    Comment.update_all({status: "approved"}, {id: params[:comment_ids]})
    redirect_to post_comments_path
  end

  private

  def comment_params
    params.require(:comment).permit(:body, :post_id, :creator, :status)
  end
end
