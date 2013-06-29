require 'mongo'

module DatabaseRepository

  class DocumentRepository
    def initialize
      @client = Mongo::MongoClient.new
      @records = @client.db("emails").collection("emails")
    end

    def save(email)
      @records.insert(email.to_hash)
    end

    def each
      @records.each do |key, value|
        yield value
      end
    end

    def delete(email)
      @records.delete("_id" => email.email_id)
    end

    def find_by_id(id)
      Email.new_from_hash(@records.find("_id" => id).to_a[0])
    end
  end

end
