# == Schema Information
# Schema version: 20110416203540
#
# Table name: users
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class User < ActiveRecord::Base
  # attr_accessible is a Rails method that will only allow access to the
  # attributes that you specify, denying the rest. attr_protected will
  # deny access to the attributes that you specify, allowing the rest,
  # and specifying neither in your model will allow access to all attributes.
  # From: http://www.ruby-forum.com/topic/95220
  attr_accessible :name, :email

  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :name,  :presence   => true,
                    :length     => { :maximum => 50 }
  validates :email, :presence   => true,
                    :format     => { :with => email_regex },
                    :uniqueness => {:case_sensitive => false}
end
