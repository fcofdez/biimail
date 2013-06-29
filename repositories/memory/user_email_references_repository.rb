module MemoryRepository
  class UserEmailReferencesRepository
    def initialize
      @records = {}
    end

    def save(email)
      @records[email.email_id]
      email
    end

    def update(email, new_reference)
      @records[email] << new_reference
    end

    def delete_reference(email, reference)
      @records[email].delete(reference)
    end

    def delete(email)
      @records.delete email
    end

    def find_by_email(email)
      @records[email]
    end
  end
end
