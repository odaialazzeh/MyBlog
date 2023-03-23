class PostsController < ApplicationController
  def index
    @user = User.find(params[:user_id])
    @posts = Post.find_by(author_id: params[:id])
  end

  def show
    @user = User.find(params[:user_id])
    @post = Post.find_by(id: params[:id])
  end

  def new
    @post = Post.new
    user_id = params[:user_id].to_i

    return unless current_user.id != user_id

    # if the current user is not the same as the user_id passed in the params, raise an exception
    raise CanCan::AccessDenied.new('Not authorized!', :create, Post)
  end

  def create
    @post = Post.new(post_params)
    @post.comments_counter = 0
    @post.likes_counter = 0
    author = current_user
    @post.author = author
    if @post.save
      flash[:success] = 'Post successfully added!'
      redirect_to user_posts_path(current_user, @post)
    else
      flash.now[:error] = 'Post creation failed!'
      render :new
    end
  end

  def destroy
    user = current_user
    @post = Post.find_by(id: params[:id], author_id: params[:user_id])
    @post.comments.destroy_all
    @post.likes.destroy_all

    if @post.destroy
      flash[:notice] = 'Post deleted!'
    else
      flash[:alert] = 'Error! Please try again later.'
    end
    if current_user.role == 'admin'
      redirect_to user_posts_path(@post.author)
    else
      redirect_to user_path(user)
    end
  end

  private

  def post_params
    params.require(:post).permit(:title, :text)
  end
end
