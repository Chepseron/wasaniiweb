class ProductionsController < ApplicationController
  skip_before_action :require_login, only: [:show, :productions_dashboard]
  before_action :set_production, only: [:show, :edit, :update, :destroy]
  before_action :load_parent, only: [:new, :create]
  autocomplete :artists, :name
  autocomplete :businesses, :name
  autocomplete :languages, :name

  # GET /productions
  # GET /productions.json
  def index
    @productions = Production.all
  end

  # GET /productions/1
  # GET /productions/1.json
  def show
    @video = VideoInfo.new(@production.trailer_url) unless @production.trailer_url.blank?

    @production.impressions.create!
    @description = ActionView::Base.full_sanitizer.sanitize(@production.synopsis).split(/\s+/).slice(0,300).join(' ');
  end

  # GET /productions/new
  def new
    @production = @parent.productions.build
  end

  # GET /productions/1/edit
  def edit
  end

  # POST /productions
  # POST /productions.json
  def create
    @production = @parent.productions.build(production_params)

    respond_to do |format|
      if @production.save
        format.html { redirect_to @production, notice: 'Production was successfully created.' }
        format.json { render :show, status: :created, location: @production }
      else
        format.html { render :new }
        format.json { render json: @production.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /productions/1
  # PATCH/PUT /productions/1.json
  def update
    respond_to do |format|
      if @production.update(production_params)
        @id = "production-#{@production.id}"
        @artist = @production.parent

        format.html { redirect_to @production, notice: 'Production was successfully updated.' }
        format.json { render :show, status: :ok, location: @production }
        format.js { render :update}
      else
        format.html { render :edit }
        format.js { render partial: 'shared/errors', locals: {entity: @production} }
      end
    end
  end

  # DELETE /productions/1
  # DELETE /productions/1.json
  def destroy
    @production.destroy
    respond_to do |format|
      format.html { redirect_to productions_url, notice: 'Production was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def productions_dashboard
    @industry_name = "Film, TV and Theater"
    @locale = params[:locale] || 'local'
    @request_path = request.path

    @artists = if @locale == 'local' && current_user
      Industry.find_by_name(@industry_name).artists.viewable.where(featured: true).where(country_of_birth: current_user.country)
    else
      Industry.find_by_name(@industry_name).artists.viewable.where(featured: true)
    end
    @specialities = Industry.find_by_name(@industry_name).artist_specialities.pluck(:name)

    @trending_artists = if @locale == 'local' && current_user
      Artist.viewable.trending_in_productions.collect{|artist| artist if artist.country_of_birth == current_user.country}.compact
    else
      Artist.viewable.trending_in_productions
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


  #autocomplete paths
  def get_directors
    directors = Artist.joins(:artist_specialities).where('artist_specialities.name = ?', 'Director').where('artists.profile_name ILIKE ?', "%#{params[:term]}%")
    render :json => directors.map { |director| {:id => director.id, :label => director.profile_name, :value => director.profile_name} }
  end

  def get_production_companies
    production_companies = Business.where('name ILIKE ?', "%#{params[:term]}%")
    render :json => production_companies.map { |production_company| {:id => production_company.id, :label => production_company.name, :value => production_company.name} }
  end

  def get_production_languages
    languages = Language.where('name ILIKE ?', "%#{params[:term]}%")
    render :json => languages.map { |language| {:id => language.id, :label => language.name, :value => language.name} }
  end

  def token_inputs
    if params[:artist_id]
      artist = Artist.find(params[:artist_id])
      render :json => artist.productions.where('title ILIKE ?',"%#{params[:q]}%").as_json(only:[:id, :title])
    else
      render :json => Production.where('title ILIKE ?',"%#{params[:q]}%").as_json(only:[:id, :title])
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_production
      @production = Production.friendly.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def production_params
      params.require(:production).permit(:cover_picture, :retained_cover_picture, :type_id, :cast_id_tags,
        :title, :country, :language_name, :running_time, :release_date, :synopsis, :director_id_tags,
        :production_company_id_tags, :trailer_url, :parent_id, :parent_type, :production_category_id)
    end
end
