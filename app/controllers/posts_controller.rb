class PostsController < ApplicationController
  skip_before_action :authenticate_user!, only: :show
  before_action :set_post, only: :show
  
  def new
    if user_signed_in?
    else
      redirect_to new_user_session_path
    end
  end

  def create
    @post = Post.new(post_params)
  end

  def show
  end

  private

  def set_post
    @post = Post.find_by(slug: params[:slug])
  end

  def post_params
    params.require(:post).permit(:title, :body)
  end
end
