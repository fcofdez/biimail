class ApplicationController < ActionController::Base
  protect_from_forgery

  private

  def is_user_signed_in?
    session[:user].present?
  end
end
