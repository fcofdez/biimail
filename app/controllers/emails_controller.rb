class EmailsController < ApplicationController
  def index
    @has_mails = $server.has_new_mail?(current_user)
    new_mails = $server.new_mails(current_user) if @has_mails
    @new_mails_length = new_mails.length if @has_mails
    @emails = []
  end

  def new
  end

  def create
    receivers = params[:email].split(",")
    email = Email.new(receivers, params[:subject], params[:message])
    $server.send(email)
    redirect_to emails_path
  end
end
