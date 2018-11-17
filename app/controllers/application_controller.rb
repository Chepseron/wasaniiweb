class ApplicationController < ActionController::Base
  before_action :require_login
  before_action :require_more_info

  include Pundit
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # Gets the current_user if anyone is logged in
  #
  # @return [Object] the currently signed in user
  def current_user
    @current_user ||= User.find_by_id(session[:user_id]) if session[:user_id]
  end
  helper_method :current_user

  def current_admin
    @current_admin ||=Admin.find_by_id(session[:admin_id]) if session[:admin_id]
  end
  helper_method :current_admin

  def require_login
    unless logged_in?
      flash[:notice] = 'You must be logged in to perform that action'
      session.delete(:user_id)
      session[:return_to] = request.referer
      redirect_to login_path and return
    end
  end

  def require_more_info
    if current_user && current_user.more_info_needed?
      flash[:notice] = 'We need a little more information from you.'
      session[:return_to] = request.referer
      redirect_to edit_user_path(current_user)
    end
  end


  def sign_in_user(user)
    session['user_id'] = user.id
    user.sign_in_count+=1
    user.last_signed_in = DateTime.now
    user.save!(validate: false)
  end

  def redirect_back_or_default(default)
    redirect_to((session[:return_to] || default), notice: 'Signed In.')
    session[:return_to] = nil
  end

  private
  def logged_in?
    !current_user.nil?
  end

  def load_parent
    resource, id = request.path.split('/')[1,2] #users/1 || businesses/1
    @parent = if resource.singularize.classify.constantize.respond_to?(:friendly)
      resource.singularize.classify.constantize.friendly.find(id) #Artist.friendly.find(1)
    else
      resource.singularize.classify.constantize.find(id) #User.find(1)
    end
  end

  def add_gallery_photos(parent, images)
    images.each do |image|
      parent.gallery_photos.create(image: image)
    end
  end

end
