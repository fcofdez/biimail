class Client

  def initialize(email_address, server, 
                 emails_repo = Repositories::Databases::Documents.new("emails", email_address))
    $repository.register(:user_emails, emails_repo)
    @email_address = email_address
    @server = server
  end

  def download_new_emails
    return unless @server.has_new_mail?(@email_address)
    @server.new_mails(@email_address).each do |email_reference|
      $repository.for(:user_emails).save(@server.fetch(@email_address, email_reference))
    end
  end

  def find_email_by_id(id)
    $repository.for(:user_emails).find_by_id(id)
  end

  def downloaded_emails
    downloaded_emails = []
    $repository.for(:user_emails).each do |email|
      downloaded_emails << email
    end
    downloaded_emails
  end

  def send_email(from, receivers, subject, body)
    @server.send(Email.new(from, receivers, subject, body))
  end
end
