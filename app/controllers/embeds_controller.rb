class EmbedsController < ApplicationController
  layout 'embed'

  before_action :set_resources

  def index
    @resources = @posts
  end

  def show
    @resource = @posts.find(params[:id])
  end

private

  def set_resources
    @user = User.find(params[:user_id])
    @blog = @user.blogs.where(id: params[:blog_id], enable: true).first if @user
    @posts = @blog.posts.where(publish: true).order('created_at DESC') if @blog
    @setting = @blog.setting if @blog
  end
end
