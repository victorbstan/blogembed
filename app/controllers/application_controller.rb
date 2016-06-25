class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def stored_location_for(resource)
    nil
  end

  def after_sign_in_path_for(resource)
    user_blogs_path(current_user, resource)
  end

private

  def is_allowed?(user_id)
    current_user && current_user.id == user_id.to_i
  end

end
