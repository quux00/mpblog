require 'spec_helper'

describe User do
  before(:each) do
    @attr = { 
      :name => "Example User", 
      :email => "user@example.com",
      :password => "foobar",
      :password_confirmation => "foobar"
    }
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
      u = User.new(@attr.merge(:password=>"", :password_confirmation=>""))
      u.should_not be_valid
    end

    it "should require a matching password confirmation" do
      u = User.new(@attr.merge(:password_confirmation=>"corpuscular"))
      u.should_not be_valid
    end

    it "should reject short passwords" do
      pw = 'a' * 5
      u = User.new(@attr.merge(:password=>pw, :password_confirmation=>pw))
      u.should_not be_valid
    end

    it "should reject long passwords" do
      pw = 'a' * 41
      u = User.new(@attr.merge(:password=>pw, :password_confirmation=>pw))
      u.should_not be_valid
    end
  end   # end of password validations

  # describe 'password encryption' do 
  #   before(:each) do
      
  #   end
  # end
  
end  # end of describe User
