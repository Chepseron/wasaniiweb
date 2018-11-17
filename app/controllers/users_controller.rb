class UsersController < ApplicationController
  skip_before_action :require_login, only: [:new, :create, :confirm_email, :accept_admin_invitation]
  skip_before_action :require_more_info, only: [:edit, :show, :update, :accept_admin_invitation]
  before_action :set_user, only: [:show, :edit, :update, :dashboard, :destroy,
    :edit_profile_pic, :update_profile_pic, :entity_management, :fanned_artists, :liked_businesses]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
    redirect_to user_path(current_user) and return unless current_user == @user
  end

  def entity_management
    redirect_to(dashboard_user_path(current_user), flash:{alert: 'You do not have permission to view that page'}) and return unless current_user.content_provider?
    @artists = (@user.artists + @user.managed_artists).uniq
    unless @user.businesses.collect{|business| business.artists}.reject!{|item| item.empty?}.nil?
      @user_business_artists = @user.businesses.collect{|business| business.artists}.reject!{|item| item.empty?}.flatten
      @artists += @user_business_artists
    end
    @businesses = (@user.businesses + @user.managed_businesses).uniq
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
    redirect_to edit_user_path(current_user) and return unless current_user == @user
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
    if @user.country.nil?
      @user.country = 'KE'
    end
    respond_to do |format|
      if @user.save
        UserMailer.registration_confirmation(@user).deliver

        format.html { redirect_to root_url, notice: 'Your account has been created and authorization sent to email. Please confirm your email to proceed.'}
        format.json { render :show, status: :created, location: @user }
      else
        flash.now[:error] = "Ooooppss, something went wrong!"
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|

      if @user.update(user_params)
        format.html { redirect_back_or_default(@user)}
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def dashboard
    @work = current_user.fanned_artists.collect{|artist| artist.works }.flatten.sort_by(&:created_at)
    @events = current_user.fanned_artists.collect(&:events).flatten.sort_by(&:created_at)
    @news_stories = current_user.fanned_artists.collect(&:news_stories).flatten.sort_by(&:created_at)

    unless @work.empty?
      unless params[:industry_id].blank?
        @industry = Industry.find(params[:industry_id])
        @work.collect!{|work| work if work.parent.industries.include?(@industry)}.reject!{|item| item.nil?}
      end

      unless params[:date].blank?
        @work.collect!{|work| work if work.date.to_date == params[:date].to_date}.reject!{|item| item.nil?}
      end

      unless params[:data_type].blank?
        @work.collect!{|work| work if work.class.name == params[:data_type].gsub(' ', '')}.reject!{|item| item.nil?}
      end
    end

    @blogs = current_user.fanned_artists.collect(&:blogs).flatten
    @news_and_blogs = (@news_stories + @blogs).sort_by(&:created_at)

    respond_to do |format|
      format.html
      format.js
    end

  end

  def fanned_artists
    @fanned_artists = @user.fanned_artists
  end

  def liked_businesses
    @businesses = @user.fanned_businesses
  end

  def confirm_email
    @user = User.find_by_email_confirmation_token(params[:id])

    if @user
      @user.email_activate!
      sign_in_user(@user)
      flash[:success] = "Welcome! Your email has been confirmed"
      redirect_to dashboard_user_path(@user)
    else
      flash[:error]= "Sorry user does not exist"
      redirect_to :root
    end
  end

  def accept_admin_invitation
    @user = User.find_by_invitation_token(params[:id])

    if @user
      @user.accept_invite!
      sign_in_user(@user)
      if current_user.more_info_needed?
        flash[:success] = "You have accepted your invitation, but we need a litte more information from you."
        redirect_to edit_user_path(current_user)
      else
        flash[:success] = "You have accepted your invitation"
        redirect_to entity_management_user_path(@user)
      end
    else
      redirect_to :root, error: "Sorry user does not exist"
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def ban
    @user = User.friendly.find(params[:id])
    policy(@user).update?
    @user.banned = true
    @user.privacy_accepted = 1

    #Transfer Ownership
    @artists = @user.artists
    @artists.each do |artist|
      artist.parent = User.find(12)
      artist.save
    end
    @businesses = @user.businesses
    @businesses.each do |biz|
      biz.parent = User.find(12)
      biz.save
    end

    #End of transfer ownership
    if current_user.destroy!
        flash[:success] = "You successfully deleted your account"
        redirect_to logout_url
    else
      flash[:error] = "Sorry, something went wrong, try again"
      redirect_to logout_url
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.friendly.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:first_name, :last_name, :email, :birthday, :privacy_accepted,
      :profile_image, :password, :password_confirmation, :country, :user_role_id, :content_provider, :newsletter, :banned)
    end
end
