class EventsController < ApplicationController
  skip_before_action :require_login, only: [:show, :events_dashboard]
  before_action :set_event, only: [:show, :edit, :update, :destroy]
  before_action :load_parent, only: [:new, :create]

  # GET /events
  # GET /events.json
  def index
    @events = Event.all
  end

  # GET /events/1
  # GET /events/1.json
  def show
    @artists = if @event.parent.is_a? Artist
      ([@event.parent] + @event.artists).flatten.uniq
    else
      @event.artists
    end
    @description = ActionView::Base.full_sanitizer.sanitize(@event.description).split(/\s+/).slice(0,300).join(' ');
    @event.impressions.create!
  end

  # GET /events/new
  def new
    @event = @parent.events.build
  end

  # GET /events/1/edit
  def edit
  end

  # POST /events
  # POST /events.json
  def create
    @event = @parent.events.build(event_params)

    respond_to do |format|
      if @event.save
        add_gallery_photos(@event, params[:images]) if params[:images]
        format.html { redirect_to @event, notice: 'Event was successfully created.' }
        format.json { render :show, status: :created, location: @event }
      else
        format.html { render :new }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /events/1
  # PATCH/PUT /events/1.json
  def update
    respond_to do |format|
      if @event.update(event_params)
        @id = "event-#{@event.id}"
        @artist = @event.parent
        add_gallery_photos(@event, params[:images]) if params[:images]
        format.html { redirect_to @event, notice: 'Event was successfully updated.' }
        format.json { render :show, status: :ok, location: @event }
        format.js {render :update}
      else
        format.html { render :edit }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  def events_dashboard
    @locale = params[:locale] || 'local'
    @type = Event

    @artists = if @locale == 'local' && current_user
      Artist.featured.viewable.where(country_of_birth: current_user.country)
    else
      Artist.featured.viewable
    end

    @featured_events = if @locale == 'local' && current_user
      Event.featured.verified.collect do |event|
        event if event.country == ISO3166::Country.find_country_by_alpha2(current_user.country).name
      end.compact
    else
      Event.featured.verified
    end

    "..@trending_artists = if @locale == 'local' && current_user
      Event.trending.collect{|artist| artist if artist.country_of_birth == current_user.country}.compact
    else
      Event.verified.trending
    end"
    @events = if @locale == 'local' && current_user
      Event.verified.trending.collect{|event| event if event.country == ISO3166::Country.find_country_by_alpha2(current_user.country).name}.compact
    else
      Event.verified.trending
    end
    @allevents = Event.verified
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @event.destroy
    respond_to do |format|
      format.html { redirect_to events_url, notice: 'Event was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def token_inputs
    render :json => Event.where('name LIKE ?',"%#{params[:q]}%").as_json(only:[:id, :name])
  end

  def get_venues
    venues = Business.where('name LIKE ?', "%#{params[:term]}%")
    render :json => venues.map { |venue| {:id => venue.id, :label => venue.name, :value => venue.name} }
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.friendly.find(params[:id])
    end



    # Never trust parameters from the scary internet, only allow the white list through.
    def event_params
      params.require(:event).permit(:name, :description, :charges, :image, :retained_image, :parent_id,
      :parent_type, :type_id, :date, :time, :event_venue_name, :artist_id_tags, :award_id_tags)
    end
end
