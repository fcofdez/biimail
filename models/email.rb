require 'date'
require 'digest'

class Email

  attr_reader :subject, :content, :receivers, :date, :downloaded_times
  attr_accessor :email_id

  def initialize(receivers, subject, content, date = Time.now, email_id = nil)
    @receivers = receivers
    @subject = subject
    @content = content
    @date = date
    @downloaded_times = 0
    @email_id = email_id || generate_hash
  end

  def self.new_from_hash(hash)
    receivers = hash["receivers"]
    subject = hash["subject"]
    content = hash["content"]
    date = hash["date"]
    email_id = hash["_id"]
    Email.new(receivers, subject, content, date, email_id)
  end

  def all_users_downloaded?
    @downloaded_times == @receivers.length
  end

  def download!
    @downloaded_times += 1
  end

  def to_hash
    Hash[instance_variables.map { |var| [var[1..-1].to_sym, instance_variable_get(var)] }]
  end

  private

  def generate_hash
    Digest::SHA1.base64digest(@subject + DateTime.now.to_s)
  end
end
