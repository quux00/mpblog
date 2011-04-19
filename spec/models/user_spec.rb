require 'spec_helper'

describe User do
  before(:each) do
    @attr = { :name => "Example User", :email => "user@example.com", :password => '&t0psecr3t'}
  end

  it "should create a new instance given valid attributes" do
    User.create!(@attr)
  end

  it "should require a name" do
    no_name_user = User.new(@attr.merge(:name=>''))
    no_name_user.valid?.should_not == true
    no_name_user.should_not be_valid  # this 'shortcut' is equiv to the line above
  end

  it "should require a valid email" do
    no_email_user = User.new(@attr.merge(:email=>''))
    no_email_user.should_not be_valid
  end

  it "should reject names that are too long" do
    long_name = 'a' * 51
    user = User.new(@attr.merge(:name => long_name))
    user.should_not be_valid
  end

  it "should accept valid email addresses" do
    addresses = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp]
    addresses.each do |address|
      valid_email_user = User.new(@attr.merge(:email => address))
      valid_email_user.should be_valid
    end
  end

  it "should reject invalid email addresses" do
    addresses = %w[user@foo,com user_at_foo.org example.user@foo.]
    addresses.each do |address|
      invalid_email_user = User.new(@attr.merge(:email => address))
      invalid_email_user.should_not be_valid
    end
  end

  it "should reject (identical) duplicate email addrs" do 
    User.create!(@attr)
    u = User.new(@attr)
    u.should_not be_valid
  end

  it "should reject email addrs identical except for case" do 
    User.create!(@attr)
    u = User.new(@attr.merge(:email=>@attr[:email].upcase))
    u.should_not be_valid
  end

  describe "password validations" do
    it "should require a password" do
      User.new(@attr.merge(:password => "", :password_confirmation => "")).
        should_not be_valid
    end

    it "should require a matching password confirmation" do
      User.new(@attr.merge(:password_confirmation => "invalid")).
        should_not be_valid
    end
    it "should reject short passwords" do
      short = "a" * 5
      hash = @attr.merge(:password => short, :password_confirmation => short)
      User.new(hash).should_not be_valid
    end
    it "should reject long passwords" do
      long = "a" * 41
      hash = @attr.merge(:password => long, :password_confirmation => long)
      User.new(hash).should_not be_valid
    end
  end

  describe "password encryption" do 
    before(:each) do
      @user = User.create!(@attr)
    end

    it "should have an encrypted password attr" do
      @user.should respond_to(:encrypted_password)
    end
    it "should set an encrypted password attr" do
      @user.encrypted_password.should_not be_blank
    end

    describe "has_password? method" do       
      it "should be true if the passwords match" do
        @user.has_password?(@attr[:password]).should be_true
      end
      it "should be false if the passwords don't match" do
        @user.has_password?("wrong").should be_false
      end
    end
    
    describe 'authentication method' do
      it "should return nil on email/password mismatch" do
        u = User.authenticate(@user.email, @user.password + "wrong")
        u.should be_nil
      end
      it "should return nil for an email address with no user" do
        nonexistent_user = User.authenticate("bar@foo.com", @attr[:password])
        nonexistent_user.should be_nil
      end
      it "should return the user on email/password match" do
        u = User.authenticate(@user.email, @user.password)
        u.should == @user
      end
    end
  end
end
