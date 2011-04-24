require 'spec_helper'

describe UsersController do
  render_views

  describe "GET 'new'" do
    it "should be successful" do
      get :new
      response.should be_success
    end
    it "should have the right title" do
      get :new
      response.should have_selector('title', :content=>'Sign up')
    end

    it "should have a name field" do
      get :new
      response.should have_selector('input#user_name')
      response.should have_selector("input[name='user[name]'][type='text']")
    end
    # <<skipped email and password fields here ...>>
    it "should have a password confirmation field" do
      get :new
      response.should have_selector('input#user_password_confirmation')
      response.should have_selector("input[name='user[password_confirmation]'][type='password']")
    end
  end

  describe "POST 'create'" do 
    describe 'success' do
      before(:each) do
        @attr = {
          :name => 'New User', :email => 'user@example.com', 
          :password => 'fuubarr',
          :password_confirmation => 'fuubarr'
        }
      end
      it 'should create a user' do
        lambda do
          post :create, :user => @attr
        end.should change(User, :count).by(1)
      end
      it 'should redirect a user to the show page' do
        post :create, :user => @attr
        response.should redirect_to(user_path(assigns(:user)))
      end
      it 'should have a welcome message' do
        post :create, :user => @attr
        flash[:success].should =~ /welcome to the sample app/i
      end
      it 'should sign the user in' do
        post :create, :user => @attr
        controller.should be_signed_in
      end
    end

    describe 'failure' do
      before(:each) do 
        @attr = {
          :name => '', :email => '', :password => '',
          :password_confirmation => ''
        }
      end

      it "should not create a user" do
        lambda do
          post :create, :user => @attr
        end.should_not change(User, :count)
      end

      it "should have the right title" do
        post :create, :user => @attr
        response.should have_selector("title", :content => "Sign up")
      end

      it "should render the 'new' page" do
        post :create, :user => @attr
        response.should render_template('new')
      end

    end
  end

  describe "GET 'show'" do
    
    before(:each) do
      @user = Factory(:user)
    end

    it 'should be successful' do
      get :show, :id => @user
      response.should be_success
    end

    it 'should find the right user' do
      get :show, :id => @user
      assigns(:user).should == @user
    end

    it 'should have the right title' do
      get :show, :id => @user
      response.should have_selector('title', :content => @user.name)
    end

    it "should have include the user's name" do
      get :show, :id => @user
      response.should have_selector('h1', :content => @user.name)
    end

    it "should have a profile image" do
      get :show, :id => @user
      response.should have_selector('h1>img', :class => 'gravatar')
    end

  end

end
