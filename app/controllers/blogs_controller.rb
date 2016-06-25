class BlogsController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_safe_resources

  # GET /blogs
  # GET /blogs.json
  def index
    @blogs = @user.blogs.all
  end

  # GET /blogs/1
  # GET /blogs/1.json
  def show
  end

  # GET /blogs/new
  def new
    @blog = @user.blogs.new
  end

  # GET /blogs/1/edit
  def edit
  end

  # POST /blogs
  # POST /blogs.json
  def create
    @blog = @user.blogs.new(blog_params)

    respond_to do |format|
      if @blog.save
        format.html { redirect_to user_blogs_path(current_user), notice: 'Blog was successfully created.' }
        format.json { render action: 'show', status: :created, location: @blog }
      else
        format.html { render action: 'new' }
        format.json { render json: @blog.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /blogs/1
  # PATCH/PUT /blogs/1.json
  def update
    respond_to do |format|
      if @blog.update(blog_params)
        format.html { redirect_to user_blogs_path(current_user), notice: 'Blog was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @blog.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /blogs/1
  # DELETE /blogs/1.json
  def destroy
    @blog.destroy
    respond_to do |format|
      format.html { redirect_to user_blogs_url(current_user) }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_resources
      @user = User.find(params[:user_id])
      @blog = @user.blogs.where(id: params[:id], enable: true).first if @user
      @posts = @blog.posts.where(publish: true) if @blog
    end

    def set_safe_resources
      @user = current_user
      @blog = current_user.blogs.find(params[:id]) if @user && params[:id]
      @posts = @blog.posts if @blog
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def blog_params
      params.require(:blog).permit(:name, :description, :enable)
    end
end
