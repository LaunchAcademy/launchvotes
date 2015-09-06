class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def new_session_path(_scope)
    root_path
  end

  def after_sign_in_path_for(_resource)
    nominations_path
  end

  def after_sign_out_path_for(_resource)
    root_path
  end
end
