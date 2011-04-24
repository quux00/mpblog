module SessionsHelper
  def sign_in(user)
    # 'remember_token' will be the cookie's name
    cookies.permanent.signed[:remember_token] = [user.id, user.salt]
    self.current_user = user  #~ don't understand this line
                              # self refers to the controller 
                              # but I can't find a current_user method on ApplicationController
                              # nor can I find a cookies method (line 4 above)
  end

  def sign_out
    #~ won't there be multiple remember_tokens with multiple users on the system?
    #~ how is this one confined to the particular user in question?
    cookies.delete(:remember_token)
    self.current_user = nil
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user
    @current_user ||= user_from_remember_token
  end

  #~ the problem is with this method - always returns false
  #~ so @current_user is never getting set ...
  def signed_in?
    !@current_user.nil?
  end



  private 

  def user_from_remember_token
    User.authenticate_with_salt(*remember_token)
  end

  def remember_token
    cookies.signed[:remember_token] || [nil, nil]
  end

end
