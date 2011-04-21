# == Schema Information
# Schema version: 20110418230308
#
# Table name: users
#
#  id                 :integer         not null, primary key
#  name               :string(255)
#  email              :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  encrypted_password :string(255)
#  salt               :string(255)
#

class User < ActiveRecord::Base
  # attr_accessible is a Rails method that will only allow access to the
  # attributes that you specify, denying the rest. attr_protected will
  # deny access to the attributes that you specify, allowing the rest,
  # and specifying neither in your model will allow access to all attributes.
  # From: http://www.ruby-forum.com/topic/95220
  attr_accessor :password
  attr_accessible :name, :email, :password, :password_confirmation

  before_save :encrypt_password

  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :name,  :presence   => true,
                    :length     => { :maximum => 50 }

  validates :email, :presence   => true,
                    :format     => { :with => email_regex },
                    :uniqueness => {:case_sensitive => false}

  validates :password, :presence     => true,
                       :confirmation => true,
                       :length       => { :within => 6..40 }

  ### class methods ###
  def self.authenticate(email, passwd)
    u = find_by_email(email)
    return nil unless u
    u.has_password?(passwd) ? u : nil
  end


  ### instance methods ###

  def has_password?(submitted_password)
    # compare the encrypted_password in the database with the
    # submitted version 
    encrypted_password == encrypt(submitted_password)
  end

  private
  def encrypt_password 
    self.salt = make_salt if new_record?
    self.encrypted_password = encrypt(password)
  end

  def make_salt
    secure_hash("#{Time.now.utc}--#{password}")
  end

  def encrypt(str)
    secure_hash("#{salt}--#{str}")
  end

  def secure_hash(str)
    Digest::SHA2.hexdigest(str)
  end

end
