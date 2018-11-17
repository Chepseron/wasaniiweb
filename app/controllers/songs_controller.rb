class SongsController < ApplicationController
  skip_before_action :require_login, only: [:show, :music_dashboard]
  before_action :set_song, only: [:show, :edit, :update, :destroy]
  before_action :load_parent, only: [:new, :create]
  autocomplete :businesses, :name

  # GET /songs
  # GET /songs.json
  def index
    @songs = Song.all
  end

  # GET /songs/1
  # GET /songs/1.json
  def show
    @video = VideoInfo.new(@song.video_url) unless @song.video_url.blank?
    @song.impressions.create!
  end

  # GET /songs/new
  def new
    @song = @parent.songs.build
  end

  # GET /songs/1/edit
  def edit
  end

  # POST /songs
  # POST /songs.json
  def create
    @song = @parent.songs.build(song_params)

    respond_to do |format|
      if @song.save
        format.html { redirect_to @song, notice: 'Song was successfully created.' }
        format.json { render :show, status: :created, location: @song }
      else
        format.html { render :new }
        format.json { render json: @song.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /songs/1
  # PATCH/PUT /songs/1.json
  def update
    respond_to do |format|
      if @song.update(song_params)
        @artist = @song.parent
        @id = "song-#{@song.id}"
        format.html { redirect_to @song, notice: 'Song was successfully updated.' }
        format.json { render :show, status: :ok, location: @song }
        format.js { render :update}
      else
        format.html { render :edit }
        format.js { render partial: 'shared/errors', locals: {entity: @song} }
      end
    end
  end

  def music_dashboard
    @industry_name = 'Music'
    @locale = params[:locale] || 'local'

    @request_path = request.path
    @artists = if @locale == 'local' && current_user
      Industry.find_by_name(@industry_name).artists.viewable.where(featured: true).where(country_of_birth: current_user.country)
    else
      Industry.find_by_name(@industry_name).artists.viewable.where(featured: true)
    end
    @specialities = Industry.find_by_name(@industry_name).artist_specialities.pluck(:name)

    @trending_artists = if @locale == 'local' && current_user
      Artist.viewable.trending_in_music.collect{|artist| artist if artist.country_of_birth == current_user.country}.compact
    else
      Artist.viewable.trending_in_music
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

  # DELETE /songs/1
  # DELETE /songs/1.json
  def destroy
    @song.destroy
    respond_to do |format|
      format.html { redirect_to songs_url, notice: 'Song was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def token_inputs
    if params[:artist_id]
      artist = Artist.find(params[:artist_id])
      render :json => artist.songs.where('title ILIKE ?',"%#{params[:q]}%").as_json(only:[:id, :title])
    else
      render :json => Song.where('title ILIKE ?',"%#{params[:q]}%").as_json(only:[:id, :title])
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_song
      @song = Song.friendly.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def song_params
      params.require(:song).permit(:title, :description, :lyrics, :audio_url,
      :video_url, :image, :country, :parent_id, :parent_type, :release_date,
      :featured_artists_id_tags, :production_company_name)
    end
end
