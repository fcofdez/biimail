require 'date'
require 'digest'

class Email

  attr_reader :suject, :content, :receivers, :date, :downloaded_times, :email_id

  def initialize(receivers, subject, content)
    @receivers = receivers
    @subject = subject
    @content = content
    @date = DateTime.now
    @downloaded_times = 0
    @email_id = generate_hash
  end

  def generate_hash
    Digest::SHA1.base64digest(suject + DateTime.now.to_s)
  end

end
