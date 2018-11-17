class PasswordResetsController < ApplicationController
  skip_before_action :require_login


  def new
  end

  def create
    user = User.find_by_email(params[:password_resets][:email])
    if user
      user.send_password_reset
      redirect_to root_url, :notice => "Email sent with password reset instructions."
    else
      redirect_to root_url, :notice => "That email address does not exist in our records."
    end
  end

  def edit
    @user = User.find_by_password_reset_token!(params[:id])
  end

  def update
    @user = User.find_by_password_reset_token(params[:id])

    if @user
      @user.attributes = params.require(:user).permit(:password, :password_confirmation)

      if @user.save(validate: false)
        @user.password_reset_token = nil
        @user.save(validate: false)

        redirect_to :login, :notice => "Password has been reset"
      else
        flash.now.alert = @user.errors.full_messages.first
        render :edit
      end
    else
      redirect_to :new_password_reset, :alert => "User does not exist"
    end
  end

end
