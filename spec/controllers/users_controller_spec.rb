require 'spec_helper'

describe UsersController do
  render_views
  
  describe "GET 'show'" do
    before(:each) do
      @testuser = Factory(:user) # create a user object to work with
    end
    
    it "should be successful" do
      get :show, :id => @testuser
      response.should be_success
    end
    
    it "should show the right user" do
      get :show, :id => @testuser
      assigns(:user).should == @testuser
    end
    
    it "should have the right title" do
      get :show, :id => @testuser
      response.should have_selector("title", :content => @testuser.name)
    end
    
    it "should include the user's name" do
      get :show, :id => @testuser
      response.should have_selector("h1", :content => @testuser.name)
    end
    
    it "should have a profile picture" do
      get :show, :id => @testuser
      response.should have_selector("h1>img", :class  => "gravatar")
    end
  end
  
  describe "GET 'new'" do
    it "should be successful" do
      get 'new'
      response.should be_success
    end
  
    it "should have the proper title" do
      get 'new'
      response.should have_selector("title", :content => "Sign up")
    end
  end

end
