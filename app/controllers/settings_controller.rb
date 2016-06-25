class SettingsController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_setting, only: [:edit, :update]

  # GET /settings/1/edit
  def edit
  end

  # PATCH/PUT /settings/1
  # PATCH/PUT /settings/1.json
  def update
    respond_to do |format|
      if @setting.update(setting_params)
        format.html { redirect_to edit_user_blog_setting_path(current_user, @blog, @setting), notice: 'Setting was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @setting.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_setting
      @blog = current_user.blogs.find(params[:blog_id])
      @setting = @blog.setting if @blog
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def setting_params
      params.require(:setting).permit(:disqus_shortname, :custom_css)
    end
end
