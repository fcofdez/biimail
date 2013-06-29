module MemoryRepository

  class EmailRepository
    def initialize
      @records = {}
    end

    def save(email)
      @records[email.email_id] = email
      email
    end

    def each
      @records.each do |key, value|
        yield value
      end
    end

    def delete(email)
      @records.delete(email.email_id)
    end

    def find_by_id(id)
      @records[id]
    end
  end

end
