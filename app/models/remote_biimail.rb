module RemoteBiimail


  # Use Mash to get hash as an objet and handle
  # better on application
  class Mashify < Faraday::Response::Middleware
    def on_complete(env)
      super if Hash === env[:body]
    end

    def parse(body)
      Mail.new_from_hash(body)
    end
  end

  module Connection
    def connection
      @connection ||= begin
                        conn = Faraday.new('http://localhost:4001/') do |c|

                          c.response :mashify
                          c.response :json, content_type: 'application/json'
                          c.use Faraday::Response::Logger,          Logger.new('log/faraday.log')
                          c.use FaradayMiddleware::FollowRedirects, limit: 3
                          c.use Faraday::Response::RaiseError       # raise exceptions on 40x, 50x responses
                          c.use Faraday::Adapter::NetHttp
                        end

                        conn
                      end
    end

    def get(path, params = nil)
      connection.get(path) do |request|
        request.params.update(params) if params
      end
    end

    def post(path, params = nil)
      connection.post(path) do |request|
        request.params.update(params) if params
      end
    end
  end

  module ApiMethods
    def get(path, params = nil)
      raw = params && params.delete(:raw)
      response = super
      puts response
      raw ? response.env[:raw_body] : response.body
    end

    def post(path, params = nil)
      raw = params && params.delete(:raw)
      response = super
      raw ? response.env[:raw_body] : response.body
    end

    def fetch_mail(receiver, id)
      response = get("emails/#{id}", receiver: receiver)
      Email.new_from_response(response)
    end

    def has_new_mail?(receiver)
      get("emails/has_new_mail", receiver: receiver).new_mails
    end

    def new_mails(receiver)
      get("emails/new_mails", receiver: receiver).map { |id| BSON::ObjectId(id) }
    end

    def send(email)
      post("emails", email.to_hash)
    end
  end

  extend Connection
  extend ApiMethods
end

