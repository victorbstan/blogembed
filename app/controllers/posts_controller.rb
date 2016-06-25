class PostsController < ApplicationController
  before_filter :authenticate_user!, except: [:show, :index]
  before_action :set_resources, only: [:show, :index]
  before_action :set_safe_resources, only: [:edit, :update, :create, :destroy]

  # GET /posts
  # GET /posts.json
  def index
    redirect_to(root_path) and return unless @blog.present?
    @post = @blog.posts.new

    if is_allowed? params[:user_id]
      @posts = @blog.posts.order('created_at DESC')
    else
      @posts = @blog.posts.where(publish: true).order('created_at DESC')
    end
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
  end

  # GET /posts/new
  def new
    @blog = current_user.blogs.find(params[:blog_id])
    @post = @blog.posts.new
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = @blog.posts.new(post_params)

    respond_to do |format|
      if @post.save
        format.html { redirect_to [current_user, @blog, @post], notice: 'Post was successfully created.' }
        format.json { render action: 'show', status: :created, location: @post }
      else
        format.html { render action: 'new' }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to [current_user, @blog, @post], notice: 'Post was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to user_blog_posts_url(current_user, @blog) }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_resources
      if is_allowed? params[:user_id]
        @user = current_user
        @blog = @user.blogs.find(params[:blog_id])
        @post = @blog.posts.find(params[:id]) if @blog && params[:id].present?
      else
        @user = User.find(params[:user_id])
        @blog = @user.blogs.where(id: params[:blog_id], enable: true).first
        @post = @blog.posts.where(id: params[:id], publish: true).first if @blog && params[:id].present?
      end
    end

    def set_safe_resources
      @blog = current_user.blogs.where(id: params[:blog_id]).first
      @post = @blog.posts.find(params[:id]) if @blog && params[:id].present?
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:title, :body, :author, :publish)
    end
end
