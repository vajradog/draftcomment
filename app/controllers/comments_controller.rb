class CommentsController < ApplicationController

  def index
    @post = Post.find(params[:post_id])
    @comments = @post.comments.all
  end
  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.new(comment_params)
    #@comment.user_id = current_user.id 
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

  

  #def edit
  #  @comment = Comment.find(params[:id])
  #  @commentable = @comment.commentable

  #end

  #def update
  #  @comment = Comment.find(params[:id])
  #  @commentable = @comment.commentable


  #  if @comment.update(comment_params)
  #    flash[:success] = "comment updated"
  #    redirect_to root_path
  #  else
  #    flash[:error] = "Could not update comment"
   #   render 'edit'
  #  end
  #end

  #def destroy
  #@comment = Comment.find(params[:id])
  #@commentable = @comment.commentable
  #if @comment.destroy
  #  flash[:success] = "Comment Destroyed!"   
  #  redirect_to :back
  #end
#end

#def approve
    #Comment.update_all({status: "approved"}, {id: params[:comment_ids]})
    #redirect_to statement_comments_path
  #end



  private

  def comment_params
    params.require(:comment).permit(:body, :post_id, :creator, :status)
  end

  #def load_commentable
   # klass = [Statement].detect { |c| params["#{c.name.underscore}_id"]}
   # @commentable = klass.find(params["#{klass.name.underscore}_id"])
  #end
end
