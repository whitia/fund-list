class UsersController < ApplicationController
  before_action :require_login, except: [:new, :create]
  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in(@user)
      redirect_to user_path(@user)
    else
      redirect_to root_path
    end
  end

  def destroy
    log_out
    User.find(params[:id]).destroy
    redirect_to root_path
  end

  private
    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation)
    end

    def require_login
      if logged_in?
        if current_user.id != params[:id].to_i
          redirect_to root_path
        end
      else
        redirect_to new_session_path
      end
    end
end
