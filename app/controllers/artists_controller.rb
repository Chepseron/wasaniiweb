class ArtistsController < ApplicationController
  skip_before_action :require_login, only: [:load_specialities, :show, :music_dashboard,
    :photo_arts_dashboard, :fashion_dashboard, :literature_dashboard, :productions_dashboard,
    :music_artist_listings, :photo_art_artist_listings, :fashion_artist_listings,
    :literature_artist_listings, :production_artist_listings, :artist_listings]
  before_action :set_artist, only: [:show, :edit, :update, :invite_page_admin, :send_admin_invitation,
    :request_ownership_transfer, :transfer_ownership, :destroy, :new_link, :create_link, :new_life_event,
    :create_life_event, :new_entity, :create_entity, :new_news_event_blog, :create_news_event_blog,
    :publish, :contacts, :book_token_inputs, :production_token_inputs, :song_token_inputs, :photo_art_token_inputs,
    :award_token_inputs, :collection_album_token_inputs]
  before_action :load_parent, only: [:new, :create]


  # GET /artists
  # GET /artists.json
  def index
    @artists = Artist.all
  end

  # GET /artists/1
  # GET /artists/1.json
  def show
    
    redirect_to :root and return if @artist.nil?
    @description = ActionView::Base.full_sanitizer.sanitize(@artist.introduction);
    if policy(@artist).update?
      @entities = @artist.works
      @news_events_blogs = (@artist.news_stories + @artist.events + @artist.blogs).uniq.sort_by(&:created_at).reverse
      @gallery_photos = @artist.gallery_photos.viewable
    else
      @entities = @artist.viewable_works
      @news_events_blogs = (@artist.news_stories.viewable + @artist.events.viewable + @artist.blogs.viewable).uniq.sort_by(&:created_at).reverse
      @gallery_photos = @artist.gallery_photos.viewable
      @artist.impressions.create!
    end
    @award_nominations = @artist.nominees.where('rank_id IS NOT NULL').uniq.sort_by(&:year).reverse
  end

  # GET /artists/new
  def new
    @artist = @parent.artists.build
  end

  # GET /artists/1/edit
  def edit
  end

  # POST /artists
  # POST /artists.json
  def create
    redirect_to :root and return unless current_user

    @artist = @parent.artists.build(artist_params)
    if @artist.country_of_birth.nil?
      @artist.country_of_birth = 'KE'
    end

    respond_to do |format|
      if @artist.save
        #data = {}
        #data[:from] = "Excited User <noreply@wasanii.com>"
        #data[:to] = "kelvinchege@gmail.com"
        #data[:subject] = "New Submission"
        #data[:html] = '<html>Name: #{@artist.name}  <a href="http://wasaniimedia.com/#{@artist.profile_name}">#{@artist.name}</a></html>'
        #RestClient.post "https://api:key-6d83de4b577d8a0c4d82f5fd3f857961"\
        #{}"@api.mailgun.net/v3/wasaniimedia.com/messages", data
        
        #@artist.send_simple_message
        #AdminMailer.new_artist_for_review(@artist).deliver!
        @artist.submit_for_review!
        format.html { redirect_to @artist, notice: 'Artist was successfully created.' }
        format.json { render :show, status: :created, location: @artist }
      else
        flash.now.alert = @artist.errors.full_messages
        format.html { render :new }
        format.json { render json: @artist.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /artists/1
  # PATCH/PUT /artists/1.json
  def update
    respond_to do |format|
      if @artist.update(artist_params)
        unless @artist.previous_changes.empty? || @artist.unreviewed?
          @artist.submit_edit!
        end
        format.html { redirect_to @artist, notice: 'Artist was successfully updated.' }
        format.json { render :show, status: :ok, location: @artist }
        format.js { render :update}
      else

        format.html { render :edit }
        format.json { render json: @artist.errors, status: :unprocessable_entity }
      end
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
      if @user.is_page_admin?(@artist)
        @user.send_admin_invitation(@artist)
        format.html { redirect_to entity_management_user_path(current_user), notice: 'The user selected is already an admin' }
        format.json { render :show, status: :ok, location: @artist }
      elsif @user.add_as_page_admin(@artist)
        format.html { redirect_to entity_management_user_path(current_user), notice: 'A new admin was successfully invited' }
        format.json { render :show, status: :ok, location: @artist }
      end
    end
  end

  def transfer_ownership
    if params[:transfer_ownership][:new_owner].blank?
      flash[:error] = 'Please select a valid selection'
      redirect_to entity_management_user_path(current_user) and return
    end

    @new_owner = User.find(params[:transfer_ownership][:new_owner])
    old_owner = @artist.parent
    @artist.parent = @new_owner
    respond_to do |format|
      if @artist.save
        old_owner.add_as_page_admin(@artist)
        format.html { redirect_to entity_management_user_path(current_user), notice: "Ownership has been transferred to #{@new_owner.name}." }
        format.json { head :no_content }
      end
    end
  end

  def token_inputs
    render :json => Artist.where('profile_name ILIKE ?',"%#{params[:q]}%").as_json(only:[:id, :profile_name])
  end

  # DELETE /artists/1
  # DELETE /artists/1.json
  def destroy
    @artist.destroy
    respond_to do |format|
      format.html { redirect_to artists_url, notice: 'Artist was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def publish
    @artist.publish!
    redirect_to @artist
  end

  #### route called by jQuery to load the form
  def load_specialities
    @artists_specialities = params[:industries].collect do |industry_id|
      Industry.find(industry_id).artist_specialities
    end.flatten if params[:industries]
  end

  ## methods for adding entities
  def new_life_event
    @parent = @artist
    @life_event = @artist.life_events.build
  end

  def create_life_event
    @life_event = @artist.life_events.build(life_event_params)
    if @life_event.save
      add_gallery_photos(@life_event, params[:images]) if params[:images]
      render :update_life_events_tree
    else
      render partial: 'shared/errors', locals: {entity: @life_event }
    end
  end

  def new_link
    @parent = @artist
    @link = @artist.links.build
  end

  def create_link
    @link = @artist.links.build(link_params)
    if @link.save
      render :update_link_details
    else
      render partial: 'shared/errors', locals: {entity: @link }
    end
  end

  def new_entity
    @parent = @artist
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
      @artist.books.build(book_params)
    elsif params.has_key? :song
      @artist.songs.build(song_params)
    elsif params.has_key? :photo_art
      @artist.photo_arts.build(photo_art_params)
    elsif params.has_key? :production
      @artist.productions.build(production_params)
    elsif params.has_key? :collection_album
      @artist.collection_albums.build(collection_album_params)
    end

    if @entity.save
      add_gallery_photos(@entity, params[:images]) if params[:images]
      render :update_entities
    else
      render partial: 'shared/errors', locals: {entity: @entity }
    end
  end

  def contacts
  end

  def new_news_event_blog
    @parent = @artist
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
      @artist.news_stories.build(news_story_params)
    elsif params.has_key? :event
      @artist.events.build(event_params)
    elsif params.has_key? :blog
      @artist.blogs.build(blog_params)
    end

    if @entity.save
      render :update_news_event_blog
    else
      render partial: 'shared/errors', locals: {entity: @entity }
    end
  end

  def book_token_inputs
    render :json => @artist.books.where('title ILIKE ?',"%#{params[:q]}%").as_json(only:[:id, :title])
  end

  def production_token_inputs
    render :json => @artist.productions.where('title ILIKE ?',"%#{params[:q]}%").as_json(only:[:id, :title])
  end

  def song_token_inputs
    render :json => @artist.songs.where('title ILIKE ?',"%#{params[:q]}%").as_json(only:[:id, :title])
  end

  def photo_art_token_inputs
    render :json => @artist.photo_arts.where('title ILIKE ?',"%#{params[:q]}%").as_json(only:[:id, :title])
  end

  def award_token_inputs
    render :json => @artist.awards.where('awards.name ILIKE ?',"%#{params[:q]}%").to_a.uniq!.as_json(only:[:id, :name])
  end

  def collection_album_token_inputs
    render :json => @artist.collection_albums.where('title ILIKE ?',"%#{params[:q]}%").as_json(only:[:id, :title])
  end

  def add_remove_fan
    @artist = Artist.friendly.find(params[:id])
    if @artist.artist_fans.collect{|af| af.user}.include?(current_user)
      @artist.artist_fans.find_by(user: current_user).delete
      following = false
    else
      @artist.artist_fans.create! user: current_user
      flash[:notice] = "You are now following #{@artist.profile_name}"
      following = true
    end

    respond_to do |format|
      format.html do
        flash[:notice] = following ? "You are now following #{@artist.profile_name}" : "You are no longer following #{@artist.profile_name}"
        redirect_to "#{request.referer}#fan-button"
      end
      format.js do
        flash.now[:notice] = following ? "You are now following #{@artist.profile_name}" : "You are no longer following #{@artist.profile_name}"
      end
    end

  end

  def artist_listings
    @industry_name = params[:industry]
    @speciality = params[:speciality]
    @locale = params[:locale] || 'local'
    @search_letter = params[:search_letter]

    @artists = if @speciality.blank?
      artists = if @locale == 'local' && current_user
        Industry.find_by_name(params[:industry]).artists.viewable.paginate(:page => params[:page], :per_page => 10).where(country_of_birth: current_user.country).where('profile_name LIKE ?', "#{params[:search_letter]}%")
      else
        Industry.find_by_name(params[:industry]).artists.viewable.paginate(:page => params[:page], :per_page => 10).where('profile_name LIKE ?', "#{params[:search_letter]}%")
      end
    else
      artists = if @locale == 'local' && current_user
        ArtistSpeciality.find_by_name(@speciality).artists.viewable.paginate(:page => params[:page], :per_page => 10).where(country_of_birth: current_user.country).where('profile_name LIKE ?', "#{params[:search_letter]}%")
      else
        ArtistSpeciality.find_by_name(@speciality).artists.viewable.paginate(:page => params[:page], :per_page => 10).where('profile_name LIKE ?', "#{params[:search_letter]}%")
      end
    end

    respond_to do |format|
      format.html
      format.js
    end
  end

  def fashion_dashboard
    @industry_name = "Fashion"
    @locale = params[:locale] || 'local'
    @request_path = request.path

    @artists = if @locale == 'local' && current_user
      Industry.find_by_name(@industry_name).artists.viewable.where(featured: true).where(country_of_birth: current_user.country)
    else
      Industry.find_by_name(@industry_name).artists.viewable.where(featured: true)
    end
    @specialities = Industry.find_by_name(@industry_name).artist_specialities.pluck(:name)

    @trending_artists = if @locale == 'local' && current_user
      Artist.viewable.trending_in_fashion.collect{|artist| artist if artist.country_of_birth == current_user.country}.compact
    else
      Artist.viewable.trending_in_fashion
    end

    @events = if @locale == 'local' && current_user
      Industry.find_by_name(@industry_name).events.viewable.collect do |event|
        event if event.country == ISO3166::Country.find_country_by_alpha2(current_user.country).name
      end.compact
    else
      Industry.find_by_name(@industry_name).events.viewable
    end

    render 'shared/entity_dashboard'
  end

  def presskit
    @artist = Artist.friendly.find(params[:id])
    if policy(@artist).update?
      @entities = @artist.works
      @news_events_blogs = (@artist.news_stories + @artist.events + @artist.blogs).uniq.sort_by(&:created_at).reverse
      @gallery_photos = @artist.gallery_photos
    else
      @entities = @artist.viewable_works
      @news_events_blogs = (@artist.news_stories.viewable + @artist.events.viewable + @artist.blogs.viewable).uniq.sort_by(&:created_at).reverse
      @gallery_photos = @artist.gallery_photos.viewable
      @artist.impressions.create!
    end
    respond_to do |format|
      format.html
      format.js
    end
  end

  # def fashion_artist_listings
#     @speciality = params[:speciality]
#     @header,@artists = case(@speciality)
#       when "models"
#         ['Models',ArtistSpeciality.find_by_name('Model').artists]
#       when 'designers'
#         ['Fashion Designers', ArtistSpeciality.find_by_name('Designer').artists]
#       when 'make-up-artists'
#         ['Makeup Artists', ArtistSpeciality.find_by_name('Makeup Artist').artists]
#       end
#
#       render 'artist_listings'
#   end



  private
    # Use callbacks to share common setup or constraints between actions.
    def set_artist
      @artist = Artist.friendly.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def artist_params
      params.require(:artist).permit(:profile_name, :name, :gender, :birthday,
      :country_of_birth, :profile_pic, :retained_profile_pic, :speciality, :introduction,
      :verified, :contact_phone_number, :contact_email, :height, :weight, :bust,
      :hips, :parent_type, :parent_id, :industry_ids=>[], :artist_speciality_ids=>[])
    end

    def life_event_params
      params.require(:life_event).permit(:date, :title, :description, :duration, :parent_id, :image, :retained_image,
      :parent_type, :life_event_category_id, :book_id_tags, :production_id_tags, :song_id_tags, :photo_art_id_tags,
      :collection_album_id_tags, :award_id_tags)
    end

    def link_params
      params.require(:link).permit(:name, :url, :parent_id, :parent_type)
    end

    def book_params
      params.require(:book).permit(:title, :isbn, :cover_pic, :retained_cover_pic,
      :summary, :parent_id, :parent_type, :country, :publishing_company_name, :publishing_date)
    end

    def song_params
      params.require(:song).permit(:title, :description, :lyrics, :audio_url,
      :video_url, :image, :country, :parent_id, :parent_type, :release_date,
      :featured_artists_id_tags, :production_company_name)
    end

    def photo_art_params
      params.require(:photo_art).permit(:title, :date, :description, :image, :retained_image, :parent_id, :parent_type, :country)
    end

    def production_params
      params.require(:production).permit(:cover_picture, :retained_cover_picture, :type_id, :cast_id_tags,
        :title, :country, :language_name, :running_time, :release_date, :synopsis, :director_id_tags,
        :production_company_id_tags, :trailer_url, :parent_id, :parent_type, :production_category_id)
    end

    def news_story_params
      params.require(:news_story).permit(:title, :date, :content, :image, :retained_image,
      :parent_type, :parent_id, :artist_id_tags, :business_id_tags, :event_id_tags)
    end

    def event_params
      params.require(:event).permit(:name, :description, :charges, :image, :retained_image, :parent_id,
      :parent_type, :type_id, :date, :enddate, :url, :time, :event_venue_name, :artist_id_tags, :award_id_tags)
    end

    def blog_params
      params.require(:blog).permit(:title, :date, :content, :parent_id, :image, :retained_image,
      :parent_type, :artist_id_tags, :business_id_tags, :event_id_tags)
    end

    def collection_album_params
      params.require(:collection_album).permit(:title, :description, :parent_id, :album_date, :cover_pic,
      :cover_pic_cover, :parent_type, :book_id_tags, :song_id_tags, :photo_art_id_tags, :production_id_tags)
    end
end
