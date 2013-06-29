require_relative '../models/client'

describe Client do

  let(:server) { Server.new }
  subject { Client.new("test@test.com", server) }

  it "return nil when user hasn't emails" do
    subject.download_new_emails.should be nil
  end

  it "return empty list when user hasn't emails" do
    subject.downloaded_emails.should == []
  end

  context "User has emails" do
    before do
      Client.new("client@test.com", server).send_email(["test@test.com"], "test", "body test")
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
