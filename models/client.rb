class Client

  attr_reader :downloaded_emails

  def initialize(email_address, server)
    @email_address = email_address
    @downloaded_emails = []
    @server = server
  end

  def download_new_emails
    return unless @server.has_new_mail?(self.email_address)
    @server.new_mails.each do |email_reference|
      @downloaded_emails << @server.fetch(receiver, email_reference)
    end
  end
end
