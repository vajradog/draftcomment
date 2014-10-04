Created this for a friend to demonstrate a simple way to set comments as 'draft' by default and then moderate them to 'approve'. Only 'approved' comments will appear to the site visitors.

This quick demo is completely bare-bone rails app (except for Zurb Foundation) and has no authentication, validation etc. built in (which you would probably want for a real site). The purpose is just to demonstrate the simple method of moderating comments. No moderation gems, just plain logic.

##usage

Assuming you have a Comment model nested under Post, create a migration and add 'status' to it, you could really name it whatever you like.

```
rails g migration add_status_to_comments
```

```
-- db/migrate/xx_add_status_to_comments.rb

class AddStatusToComments < ActiveRecord::Migration
  def change
  	add_column :comments, :status, :string
  end
end
```
```
rake db:migrate
```

Once we have this status column we can scope it like so:

```
-- user.rb

class Comment < ActiveRecord::Base
  belongs_to :post
  scope :approved, -> { where status: 'approved'}
  scope :draft, -> { where status: 'draft'}
end
```

In your comments controller add the @comment.status line so all new comments are saved as "draft"

```
-- comments_controller.rb

def create
  @post = Post.find(params[:post_id])
  @comment = @post.comments.new(comment_params)
  @comment.status = "draft"
  ...
  ...
end
  ```
 
 Add a new definited called 'approved' in the same controller and don't forget to add the status to your comment_params
 
 ```
 -- comments_controller.rb
  
 def approve
    Comment.update_all({status: "approved"}, {id: params[:comment_ids]})
    redirect_to post_comments_path
  end
  
 private
 
 def comment_params
   params.require(:comment).permit(:body, :post_id, :status)
 end
  ```
 
Now, it's pretty much setup. Edit your routes to include our status

```
-- routes.rb

resources :posts do
  resources :comments do
    collection do
      put :approve
    end
  end
end
```

In the views folder, you can create a partial for the comments and put it in the posts/show page.

```
-- views/comments/_comments.html.erb
-- notice that only approved comments are shown.

<% @comments.approved.each do |comment| %>
  <%= simple_format(comment.body) %>
<% end %>

---views/posts/show.html.erb
--- add the comments wherever you want to display it also add the form etc.

 <%= render "comments/comments" %>

```
Now we need a page to moderate all the comments. Create a new page in the comments folder.

```
--- views/comments/index.html.erb

it's too much to write here, so check the folder above or here's the direct link: https://github.com/vajradog/draftcomment/blob/master/app/views/comments/index.html.erb

```

That's it. Now the moderation dashboard link will be something like: http://localhost:3000/posts/1/comments assuming we're talking about post with id: 1

You can also add a button (only accessible by you: admin) somewhere on the post page, like so:

```
<%= link_to "Moderate #{pluralize @comments.draft.size, ('comment')}", post_comments_path(@post), class: "button alert small"%>
	