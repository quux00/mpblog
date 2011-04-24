class UsersController < ApplicationController
  def new
    @user = User.new
    @title = "Sign up"
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in(@user)
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
      # render user_path(@user)  #~TODO: is this synonymous to the line above?
                                 # answer: no - render and redirect do something different
                                 # the render version does not pass the unit test
    else
      @title = "Sign up"
      @user.password = ''
      @user.password_confirmation = ''
      render new_user_path
      # render 'new'    #~TODO: is this synonymous to the line above?
    end
  end

  def show
    @user = User.find(params[:id])
    sign_in(@user)  #~TODO: not sure this is right (not in book?)
    @title = @user.name
  end

end
