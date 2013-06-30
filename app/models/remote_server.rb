class RemoteServer
  def send(email)
    RemoteBiimail.send(email)
  end

  def fetch(receiver, email_id)
    RemoteBiimail.fetch_mail(receiver, email_id.to_s)
  end

  def has_new_mail?(receiver)
    RemoteBiimail.has_new_mail?(receiver)
  end

  def new_mails(receiver)
    RemoteBiimail.new_mails(receiver)
  end
end
