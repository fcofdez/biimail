require_relative 'server'
require_relative 'email'

class Client

  attr_reader :downloaded_emails

  def initialize(email_address, server)
    @email_address = email_address
    @downloaded_emails = []
    @server = server
  end

  def download_new_emails
    return unless @server.has_new_mail?(@email_address)
    @server.new_mails(@email_address).each do |email_reference|
      @downloaded_emails << @server.fetch(@email_address, email_reference)
    end
  end

  def send_email(receivers, subject, body)
    @server.send(Email.new(receivers, subject, body))
  end
end
