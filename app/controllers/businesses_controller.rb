class BusinessesController < ApplicationController
  skip_before_action :require_login, only: [:show, :businesses_dashboard, :business_listings ]
  before_action :set_business, only: [:show, :edit, :update, :invite_page_admin, :send_admin_invitation,
    :request_ownership_transfer, :transfer_ownership, :destroy, :new_news_event_blog, :create_news_event_blog,
    :new_link, :create_link, :new_entity, :create_entity]

  # GET /businesses
  # GET /businesses.json
  def index
    @businesses = Business.verified.all
  end

  # GET /businesses/1
  # GET /businesses/1.json
  def show
    if policy(@business).update?
      @work = @business.works
      @news_events_blogs = @business.news_stories + [@business.events + @business.hosted_events].flatten.uniq + @business.blogs
    else
      @work = @business.viewable_works
      @news_events_blogs = @business.news_stories.viewable + [@business.events.viewable + @business.hosted_events.viewable].flatten.uniq + @business.blogs.viewable
    end

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
    @description = ActionView::Base.full_sanitizer.sanitize(@business.company_info);

    respond_to do |format|
      format.html { @business.impressions.create! }
      format.js
    end
  end

  # GET /businesses/new
  def new
    @business = current_user.businesses.build
  end

  # GET /businesses/1/edit
  def edit
  end

  # POST /businesses
  # POST /businesses.json
  def create
    @business = current_user.businesses.build(business_params)
    if @business.country.nil?
      @business.country = 'KE'
    end

    respond_to do |format|
      if @business.save
        format.html { redirect_to @business, notice: 'Business was successfully created.' }
        format.json { render :show, status: :created, location: @business }
      else
        format.html { render :new }
        format.json { render json: @business.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /businesses/1
  # PATCH/PUT /businesses/1.json
  def update
    respond_to do |format|
      if @business.update(business_params)
        format.html { redirect_to @business, notice: 'Business was successfully updated.' }
        format.json { render :show, status: :ok, location: @business }
        format.js
      else
        format.html { render :edit }
        format.json { render json: @business.errors, status: :unprocessable_entity }
        format.js
      end
    end
  end

  def new_entity
    @parent = @business
    # byebug
    @entity_type = params[:entity_type]
    case @entity_type
    when 'book'
      @book = @parent.books.build
      return @book
    when 'song'
      @song = @parent.songs.build
      return @song
    when 'photo_art'
      @photo_art = @parent.photo_arts.build
      return @photo_art
    when 'production'
      @production = @parent.productions.build
      return @production
    when 'collection_album'
      @collection_album = @parent.collection_albums.build
      return @collection
    end
  end

  def create_entity
    @entity = if params.has_key? :book
      @business.books.build(book_params)
    elsif params.has_key? :song
      @business.songs.build(song_params)
    elsif params.has_key? :photo_art
      @business.photo_arts.build(photo_art_params)
    elsif params.has_key? :production
      @business.productions.build(production_params)
    elsif params.has_key? :collection_album
      @business.collection_albums.build(collection_album_params)
    end

    if @entity.save
      add_gallery_photos(@entity, params[:images]) if params[:images]
      render :update_entities
    else
      render partial: 'shared/errors', locals: {entity: @entity }
    end
  end

  # DELETE /businesses/1
  # DELETE /businesses/1.json
  def destroy
    @business.destroy
    respond_to do |format|
      format.html { redirect_to businesses_url, notice: 'Business was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def businesses_dashboard
    @locale = params[:locale] || 'local'
    @request_path = request.path

    @featured_businesses = if @locale == 'local' && current_user
      Business.verified.featured.where(country: current_user.country).limit(7)
    else
      Business.verified.featured.limit(7)
    end

    @businesses = if @locale == 'local' && current_user
      Business.verified.paginate(:page => params[:page], :per_page => 10).where(country: current_user.country).viewable.paginate(:page => params[:page], :per_page => 10)
    else
      Business.verified.paginate(:page => params[:page], :per_page => 10).viewable
    end
  end

  def business_listings
    @industry = Industry.find_by_id(params[:industry])
    @locale = params[:locale] || 'local'
    @search_letter = params[:search_letter]

    if @industry.nil?
      @header = 'Businesses'
      @businesses = if @locale == "local" && current_user
        Business.verified.paginate(:page => params[:page], :per_page => 10).where(country: current_user.country).viewable.where('name LIKE ?', "#{params[:search_letter]}%")
      else
        Business.verified.paginate(:page => params[:page], :per_page => 10).where('name LIKE ?', "#{params[:search_letter]}%")
      end
    else
      @header = @industry.name
      @industry_id = @industry.id
      @businesses = if @locale == "local" && current_user
        @industry.businesses.verified.paginate(:page => params[:page], :per_page => 10).where(country: current_user.country).where('name LIKE ?', "#{params[:search_letter]}%")
      else
        @industry.businesses.verified.paginate(:page => params[:page], :per_page => 10).where('name LIKE ?', "#{params[:search_letter]}%")
      end
    end

    respond_to do |format|
      format.html
      format.js
    end
  end

  def token_inputs
    render :json => Business.viewable.where('name LIKE ?',"%#{params[:q]}%").as_json(only:[:id, :name])
  end

  def new_news_event_blog
    @parent = @business
    @request = params[:request].downcase
    case @request
    when 'add a news story'
      @news_story = @parent.news_stories.build
      return @news_story
    when 'add an event'
      @event = @parent.events.build
      return @event
    when 'add a blog'
      @blog = @parent.blogs.build
      return @blog
    end
  end

  def create_news_event_blog
    @entity = if params.has_key? :news_story
      @business.news_stories.build(news_story_params)
    elsif params.has_key? :event
      @business.events.build(event_params)
      Rails.logger.debug event_params
      
    elsif params.has_key? :blog
      @business.blogs.build(blog_params)
    end

    if @entity.save
      render :update_news_event_blog
    else
      render partial: 'shared/errors', locals: {entity: @entity }
    end
  end

  def new_link
    @parent = @business
    @link = @business.links.build
  end

  def create_link
    @link = @business.links.build(link_params)
    if @link.save
      render :update_link_details
    else
      render partial: 'shared/errors', locals: {entity: @link }
    end
  end

  def send_admin_invitation
    if params[:invitation][:email_address].blank?
      flash[:error] = 'Please enter an email address'
      redirect_to entity_management_user_path(current_user) and return
    end

    @user = User.find_by_email params[:invitation][:email_address]
    if @user.nil?
      @user = User.new(email: params[:invitation][:email_address])
      @user.save!(validate: false)
    end

    respond_to do |format|
      if @user.is_page_admin?(@business)
        @user.send_admin_invitation(@business)
        format.html { redirect_to entity_management_user_path(current_user), notice: 'The user selected is already an admin' }
        format.json { render :show, status: :ok, location: @business }
      elsif @user.add_as_page_admin(@business)
        format.html { redirect_to entity_management_user_path(current_user), notice: 'A new admin was successfully invited' }
        format.json { render :show, status: :ok, location: @business }
      end
    end
  end

  def transfer_ownership
    if params[:transfer_ownership][:new_owner].blank?
      flash[:error] = 'Please select a valid selection'
      redirect_to entity_management_user_path(current_user) and return
    end

    @new_owner = User.find(params[:transfer_ownership][:new_owner])
    old_owner = @business.parent
    @business.parent = @new_owner
    respond_to do |format|
      if @business.save
        old_owner.add_as_page_admin(@business)
        format.html { redirect_to entity_management_user_path(current_user), notice: "Ownership has been transferred to #{@new_owner.name}." }
        format.json { head :no_content }
      end
    end
  end

  def add_remove_fan
    @business = Business.friendly.find(params[:id])
    if @business.business_fans.collect{|bf| bf.user}.include?(current_user)
      @business.business_fans.find_by(user: current_user).delete
      following = false
    else
      @business.business_fans.create! user: current_user
      following = true
    end

    respond_to do |format|
      format.html do
        flash[:notice] = following ? "You are now following #{@business.name}" : "You are no longer following #{@business.name}"
        redirect_to "#{request.referer}#fan-button"
      end

      format.js do
        flash.now[:notice] = following ? "You are now following #{@business.name}" : "You are no longer following #{@business.name}"
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_business
      @business = Business.friendly.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def business_params
      params.require(:business).permit(:name, :logo, :retained_logo, :country, :latitude,
      :longitude, :business_category_id, :company_info, :physical_location, :phone_number, :email,
      :working_hours, industry_ids: [])
    end

    def production_params
      params.require(:production).permit(:cover_picture, :retained_cover_picture, :type_id, :cast_id_tags,
        :title, :country, :language_name, :running_time, :release_date, :synopsis, :director_id_tags,
        :production_company_id_tags, :trailer_url, :parent_id, :parent_type, :production_category_id)
    end

    def news_story_params
      params.require(:news_story).permit(:title, :date, :content, :image, :retained_image,
      :parent_type, :parent_id, artist_ids:[], business_ids:[], event_ids:[])
    end

    def event_params
      params.require(:event).permit(:name, :description, :charges, :image, :retained_image, :parent_id,
      :parent_type, :type_id, :date, :time, :event_venue_name, :artist_id_tags, :award_id_tags)
    end

    def blog_params
      params.require(:blog).permit(:title, :date, :content, :parent_id, :image, :retained_image,
      :parent_type, artist_ids:[], business_ids:[], event_ids:[])
    end

    def link_params
      params.require(:link).permit(:name, :url, :parent_id, :parent_type)
    end
end
