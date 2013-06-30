class SessionsController < ApplicationController

  def create
    session[:user] = params[:email]
    redirect_to emails_path
  end

  def destroy
    session[:user] = nil
  end
end
