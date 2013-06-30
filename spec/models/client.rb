require_relative '../../app/models/client'
require_relative '../../app/models/server'
require_relative '../../app/models/repository'
require_relative '../../app/models/email'
require_relative '../../app/models/repositories/memory/emails'
require_relative '../../app/models/repositories/memory/user_email_references'

describe Client do

  before do
    $repository = Repository.new
  end
  let(:server) { Server.new(Repositories::Memory::Emails.new,
                            Repositories::Memory::UserEmailReferences.new) }
  subject { Client.new("test@test.com", server, Repositories::Memory::Emails.new) }

  it "return nil when user hasn't emails" do
    subject.download_new_emails.should be nil
  end

  it "return empty list when user hasn't emails" do
    subject.downloaded_emails.should == []
  end

  context "User has emails" do
    before do
      Client.new("client@test.com", server, Repositories::Memory::Emails.new).send_email("me@me.com", ["test@test.com"], "test", "body test")
    end

    it "return email instance" do
      subject.download_new_emails
      subject.downloaded_emails.first.class.should == Email
    end

    it "return email subject" do
      subject.download_new_emails
      subject.downloaded_emails.first.subject == "test"
    end

    it "return email body" do
      subject.download_new_emails
      subject.downloaded_emails.first.content == "body test"
    end
  end
end
