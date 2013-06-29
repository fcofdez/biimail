require_relative 'models/client'
require_relative 'models/server'

server = Server.new
client = Client.new("francisco.fernandez.castano@gmail.com", server)

client.send_email(["fercas@gmail.com", "test@test.com", "test2@test.com"], "test", "hello world")

client = Client.new("fercas@gmail.com", server)

client.download_new_emails
puts client.downloaded_emails.inspect
client = Client.new("test@test.com", server)

client.download_new_emails
puts client.downloaded_emails.inspect

puts server.has_new_mail?("test2@test.com")
