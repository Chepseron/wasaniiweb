class SessionsController < ApplicationController
  skip_before_action :require_login
  skip_before_action :require_more_info

  def new
    redirect_to :root if current_user

    respond_to do |format|
      format.html
      format.js { render js: "window.location.pathname='#{login_path}'", error: 'Please log in to complete that action.'}
    end
  end

  def create
    @user = User.find_by_email(params[:sessions][:email])

    respond_to do |format|
      if @user && @user.authenticate(params[:sessions][:password]) && !@user.banned?
        if @user.email_confirmed?
          sign_in_user(@user)
          format.html { redirect_back_or_default(dashboard_user_path(@user)) }
          format.json { render :show, status: :created, location: @user }
        else
          format.html do
            flash[:error] = "Please activate your account by the following instructions in the account confirmation email you received to proceed"
            redirect_to :root
          end
          format.json { render json: { error: 'Please activate your account by the
              following instructions in the account confirmation email you received to proceed'}, status: :unprocessable_entity }
        end
      elsif @user && @user.banned?
        format.html do
          flash[:error] = "This account does not exist"
          redirect_to :root
        end
      else
        format.html do
          flash.now[:error] = "Username/Password combination is incorrect"
          render :new
        end
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def omniauth_create
    begin
      @user = User.from_omniauth(request.env['omniauth.auth'])

      sign_in_user(@user)
      flash[:success] = "Welcome, #{@user.name}!"
      # for some reason the test skip the before_action with omniauth
      # so we have to handle this redirect ourselves
      if @user.more_info_needed?
        flash[:notice] = 'We need a little more information from you.'
        redirect_to edit_user_path(@user) and return
      else
        redirect_to dashboard_user_path(@user) and return
      end
    rescue
      flash[:error] = "There was an error while trying to authenticate you..."
      redirect_to root_path  and return
    end
  end

  def auth_failure
    flash[:error] = "There was an error while trying to authenticate you..."
    redirect_to root_path and return
  end

  def destroy
    session.delete(:user_id)
    redirect_to :root
  end

  def destroyuser
    session.delete(:user_id)
    redirect_to :root
  end

  def failure
    flash[:alert] = t('controllers.sessions.failure', provider: pretty_name(env['omniauth.error.strategy'].name))
    render_or_redirect and return
  end

  def render_or_redirect
    page = env['omniauth.origin']
    if env['omniauth.params']['popup']
      @page = page
      render 'callback', layout: false
    else
      redirect_to page
    end
  end
end
