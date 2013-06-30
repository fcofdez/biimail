class EmailsController < ApplicationController
  before_filter :instantiate_client

  def index
    @has_mails = $server.has_new_mail?(current_user)
    new_mails = $server.new_mails(current_user) if @has_mails
    @new_mails_length = new_mails.length if @has_mails
    @emails = @client.downloaded_emails
  end

  def new
  end

  def create
    receivers = params[:email].split(",")
    @client.send_email(receivers, params[:subject], params[:message])
    redirect_to emails_path
  end

  def download
    @client.download_new_emails
  end

  private

  def instantiate_client
    @client = Client.new(current_user, $server)
  end
end
