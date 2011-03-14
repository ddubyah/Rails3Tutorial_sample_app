class UsersController < ApplicationController
  before_filter :authenticate,      :only => [:edit, :update, :index]
  before_filter :correct_user,      :only => [:edit, :update]
  before_filter :admin_user,        :only => :destroy
  before_filter :no_self_delete,    :only => :destroy
  before_filter :block_signed_user, :only => [:new, :create]
  
  def new
    @user = User.new
    @title = "Sign up now!"
  end
  
  def index
    @title = "All users"
    @users = User.paginate(:page => params[:page])
  end
  
  def show
    @user = User.find(params[:id])
    @title = @user.name
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      @title = "Sign up now!"
      @user.password = ""
      @user.password_confirmation = ""
      render 'new'
    end
  end
  
  def edit
    @title = "Edit user"
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      @title = "Edit user"
      render 'edit'
    end
  end
  
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User destroyed."
    redirect_to users_path
  end
  
  private
  
    def authenticate
      deny_access unless signed_in?
    end
    
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end
    
    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end
    
    def no_self_delete
      if current_user?(User.find(params[:id]))
        flash[:error] = "You can't delete yourself"
        redirect_to(users_path)
      end
    end
    
    def block_signed_user
      redirect_to(root_path) if signed_in?
    end
end
