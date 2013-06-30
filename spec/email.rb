require_relative '../models/email'

describe Email do
  subject { Email.new("me@me.com", ["test@test.com"], "Subject", "body test") }

  it "return 0 when nobody have downloaded it" do
    subject.downloaded_times.should == 0
  end

  it "#all_users_downloaded? return false when nobody have downloaded it" do
    subject.all_users_downloaded?.should be false
  end

  context "Some receivers download this email" do
    it "#all_users_downloaded? return true when all users have downloaded it" do
      subject.download!
      subject.all_users_downloaded?.should be true
    end

    it "return 1 when some receiver has downloaded it" do
      subject.download!
      subject.downloaded_times.should == 1
    end
  end

  it "return hash" do
    subject.to_hash.class.should == Hash
  end

end
