class Server

  def initialize
    Repository.register(:emails, MemoryRepository::EmailRepository.new)
    Repository.register(:user_email_references, MemoryRepository::UserEmailReferencesRepository.new)
  end

  def send(email)
    Repository.for(:emails).save(email)

    email.receivers.each do |receiver|
      Repository.for(:user_email_refereces).update(receiver, email.email_id)
    end
  end

  def fetch(receiver, email_id)
    email = Repository.for(:emails).find_by_id(email_id)
    Repository.for(:user_email_refereces).delete_reference(receiver, email_id)
    email.read!
    Repository.for(:emails).delete(email) if email.all_users_read_it?
    email
  end

  def has_new_mail?(receiver)
    Repository.for(:user_email_refereces).find_by_email(receiver).length > 0
  end

  def new_mails
    Repository.for(:user_email_refereces).find_by_email(receiver)
  end

end
