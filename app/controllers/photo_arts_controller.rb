class PhotoArtsController < ApplicationController
  skip_before_action :require_login, only: [:show, :photo_arts_dashboard]
  before_action :set_photo_art, only: [:show, :edit, :update, :destroy]
  before_action :load_parent, only: [:new, :create]

  # GET /photo_arts
  # GET /photo_arts.json
  def index
    @photo_arts = PhotoArt.all
  end

  # GET /photo_arts/1
  # GET /photo_arts/1.json
  def show
    @photo_art.impressions.create!
  end

  # GET /photo_arts/new
  def new
    @photo_art = @parent.photo_arts.build
  end

  # GET /photo_arts/1/edit
  def edit
  end

  # POST /photo_arts
  # POST /photo_arts.json
  def create
    @photo_art = @parent.photo_arts.build(photo_art_params)

    respond_to do |format|
      if @photo_art.save
        add_gallery_photos(@photo_art, params[:images]) if params[:images]
        format.html { redirect_to @photo_art, notice: 'Photo art was successfully created.' }
        format.json { render :show, status: :created, location: @photo_art }
      else
        format.html { render :new }
        format.json { render json: @photo_art.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /photo_arts/1
  # PATCH/PUT /photo_arts/1.json
  def update
    respond_to do |format|
      if @photo_art.update(photo_art_params)
        @id = "photoart-#{@photo_art.id}"
        @artist = @photo_art.parent

        add_gallery_photos(@photo_art, params[:images]) if params[:images]

        format.html { redirect_to @photo_art, notice: 'Photo art was successfully updated.' }
        format.json { render :show, status: :ok, location: @photo_art }
        format.js { render :update}
      else
        format.html { render :edit }
        format.js { render partial: 'shared/errors', locals: {entity: @photo_art} }
      end
    end
  end

  def photo_arts_dashboard
    @industry_name = "Art and Design"
    @locale = params[:locale] || 'local'

    @request_path = request.path
    @artists = if @locale == 'local' && current_user
      Industry.find_by_name(@industry_name).artists.viewable.where(featured: true).where(country_of_birth: current_user.country)
    else
      Industry.find_by_name(@industry_name).artists.viewable.where(featured: true)
    end
    @specialities = Industry.find_by_name(@industry_name).artist_specialities.pluck(:name)

    @trending_artists = if @locale == 'local' && current_user
      Artist.viewable.trending_in_art.collect{|artist| artist if artist.country_of_birth == current_user.country}.compact
    else
      Artist.viewable.trending_in_art
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

  # DELETE /photo_arts/1
  # DELETE /photo_arts/1.json
  def destroy
    @photo_art.destroy
    respond_to do |format|
      format.html { redirect_to photo_arts_url, notice: 'Photo art was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def token_inputs
    if params[:artist_id]
      artist = Artist.find(params[:artist_id])
      render :json => artist.photo_arts.where('title ILIKE ?',"%#{params[:q]}%").as_json(only:[:id, :title])
    else
      render :json => PhotoArt.where('title ILIKE ?',"%#{params[:q]}%").as_json(only:[:id, :title])
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_photo_art
      @photo_art = PhotoArt.friendly.find(params[:id])
    end



    # Never trust parameters from the scary internet, only allow the white list through.
    def photo_art_params
      params.require(:photo_art).permit(:title, :date, :description, :image, :retained_image, :parent_id, :parent_type, :country)
    end
end
