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
      get :new
      response.should be_success
    end
  
    it "should have the proper title" do
      get 'new'
      response.should have_selector("title", :content => "Sign up")
    end
  end

  describe "POST 'create" do
    describe "failure" do
      before(:each) do
        @attr = { :name                   => "",
                  :email                  => "",
                  :password               => "",
                  :password_confirmation  => ""
                  }
      end
      
      it "should not create a user" do
        lambda do
          post :create, :user => @attr
        end.should_not change(User, :count)
      end
      
      it "should have the right title" do
        post :create, :user => @attr
        response.should have_selector("title", :content => "Sign up now!")
      end
      
      it "should render the 'new' page" do
        post :create, :user => @attr
        response.should render_template('new')
      end
      
      it "should blank the password fields" do
        lambda do
          post :create, :user => @attr.merge( :name => "The Dude",
                                            :email                  => "abides@thebeach.net",
                                            :password               => "finbar",
                                            :password_confirmation  => "mismatch")
          response.should render_template('new')
          response.should have_selector('input#user_password', :value => '')
          response.should have_selector('input#user_password_confirmation', :value => '')
        end.should_not change(User, :count)
      end
  
    end
      
    describe "success" do
      before(:each) do
        @attr = { :name                   => "New User",
                  :email                  => "user@email.com",
                  :password               => "foobar",
                  :password_confirmation  => "foobar"}
      end
      
      it "should create a user" do
        lambda do
          post :create, :user => @attr
        end.should change(User, :count).by(1)
      end
      
      it "should redirect to the user show page" do
        post :create, :user => @attr
        response.should redirect_to(user_path(assigns(:user)))
      end
      
      it "should have a welcome message" do
        post :create, :user => @attr
        flash[:success].should =~ /welcome to the sample app/i
      end
      
      it "should sign the user in" do
        post :create, :user => @attr
        controller.should be_signed_in
      end
    end
  end

  describe "GET 'edit" do
    before(:each) do
      @user = Factory(:user)
      test_sign_in(@user)
    end
    
    it "should be successful" do
      get :edit, :id => @user
      response.should be_success
    end
    
    it "should have the right title" do
      get :edit, :id => @user
      response.should have_selector("title", :content => "Edit user")
    end
    
    it "should have a link to change the Gravatar" do
      get :edit, :id => @user
      gravatar_url = "http://gravatar.com/emails"
      response.should have_selector("a",  :href     => gravatar_url,
                                          :content  => "change")
    end
  end
  
  describe "PUT 'update'" do
    before(:each) do
      @user = Factory(:user)
      test_sign_in(@user)
    end
    
    describe "failure" do
      before(:each) do
        @attr = { :email                  => "", 
                  :name                   => "",
                  :password               => "",
                  :password_confirmation  => ""}
      end

      it "should render the 'edit' page" do
        put :update, :id => @user, :user => @attr
        response.should render_template('edit')
      end
      
      it "should have the right title" do
        put :update, :id => @user, :user => @attr
        response.should have_selector("title", :content => "Edit user")
      end
    end
    
    describe "success" do
      
      before(:each) do
        @attr = { :name => "New Name", :email => "user@example.org",
                  :password => "barbaz", :password_confirmation => "barbaz" }
      end
      
      it "should change the user's attributes" do
        put :update, :id => @user, :user => @attr
        @user.reload
        @user.name.should  == @attr[:name]
        @user.email.should == @attr[:email]
      end
      
      it "should redirect to the user show page" do
        put :update, :id => @user, :user => @attr
        response.should redirect_to(user_path(@user))
      end
      
      it "should have a flash message" do
        put :update, :id => @user, :user => @attr
        flash[:success].should =~ /updated/
      end
    end
    
  end

end


