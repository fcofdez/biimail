class Server
  
  def initialize
    Repository.register(:emails, MemoryRepository::EmailRepository.new)
    Repository.register(:user_email_references, MemoryRepository::UserEmailReferencesRepository.new)
  end

  def send(email)
  end

  def fetch(email)
  end
end
