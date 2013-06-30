require_relative '../../app/models/client'
require_relative '../../app/models/server'
require_relative '../../app/models/repository'
require_relative '../../app/models/email'
require_relative '../../app/models/repositories/memory/emails'
require_relative '../../app/models/repositories/memory/user_email_references'

describe Server do

  before do
    $repository = Repository.new
  end
  subject { Server.new(Repositories::Memory::Emails.new,
                       Repositories::Memory::UserEmailReferences.new) }

  it "Store emails" do
    subject.send(Email.new("me@me.com", ["test@test.com"], "test", "body test"))
    subject.new_mails("test@test.com").should_not == []
  end

  it "Store emails" do
    subject.new_mails("test@test.com").should == []
  end

  it "#has_new_mail? check if user has new emails" do
    subject.send(Email.new("me@me.com", ["test@test.com"], "test", "body test"))
    subject.has_new_mail?("test@test.com").should be true
  end

  it "#has_new_mail? check if user has new emails" do
    subject.has_new_mail?("test@test.com").should be false
  end

  it "fetch emails" do
    subject.send(Email.new("me@me.com", ["test@test.com"], "test", "body test"))
    subject.fetch("test@test.com", subject.new_mails("test@test.com").first)
    subject.has_new_mail?("test@test.com").should be false
  end

end
