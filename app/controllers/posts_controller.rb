class PostsController < ApplicationController
  skip_before_action :authenticate_user!, only: :show
  before_action :set_post, only: [:show, :edit]
  
  def new
    redirect_to new_user_session_path unless user_signed_in?
  end

  def create
    @post = Post.new(post_params)
    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: 'Post was successfully created.' }
        format.json { render json: @post, status: :created, location: @post }
      else
        format.html { render action: "new" }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
  end

  def edit
  end

  private

  def set_post
    @post = Post.find_by(slug: params[:slug])
  end

  def post_params
    params.require(:post).permit(:title, :body, :email)
  end
end
