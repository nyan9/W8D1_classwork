class UsersController < ApplicationController

  before_action :require_logged_in, except: [:new, :create]

  def new
    @user = User.new
    render :new
  end
  
  def index
    @users = User.all
    render :index
  end

  def show
    @user = User.find_by_id(params[:id])
    if @user
      render :show
    else
      flash[:errors] = ['User not found!']
      redirect_to users_url
    end
  end

  def create
    @user = User.new(user_params)
    # debugger
    if @user.save
      login!(@user)
      redirect_to user_url(@user)
    else
      flash.now[:errors] = @user.errors.full_messages
      render :new
    end
  end

  def edit
    @user = User.find_by_id(params[:id])
    render :edit
  end

  def update
    @user = User.find_by_id(params[:id])
    if @user && @user.update(user_params)
      redirect_to user_url(@user)
    else
      flash[:errors] = @user.errors.full_messages
      redirect_to edit_user_url(@user)
    end
  end

  def destroy
    @user = User.find_by_id(params[:id])
    if @user
      @user.delete 
      session[:session_token] = nil
      @current_user = nil
      redirect_to new_user_url
    else
      flash[:errors] = @user.errors.full_messages
      redirect_to edit_user_url(@user)
    end
  end

  def user_params
    params.require(:user).permit(:username, :password)
  end

end