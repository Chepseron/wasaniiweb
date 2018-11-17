class NomineesController < ApplicationController
  before_action :set_nominee, only: [:show, :edit, :update, :destroy]
  before_action :load_parent, only: [:new, :create]

  # GET /nominees
  # GET /nominees.json
  def index
    @nominees = Nominee.all
  end

  # GET /nominees/1
  # GET /nominees/1.json
  def show
  end

  # GET /nominees/new
  def new
    @nominee = @parent.nominees.build

    render 'new_nominee'
  end

  # GET /nominees/1/edit
  def edit
    @parent = @nominee.award_category
    render 'edit_nominee'
  end

  # POST /nominees
  # POST /nominees.json
  def create
    @award_category = @parent
    Nominee.current_category = @parent
    @nominee = @parent.nominees.build(nominee_params)

    respond_to do |format|
      if @nominee.save
        format.html {redirect_to @award_category, notice: 'Nominee was successfully created.'}
        format.js {@nominees = @award_category.nominees.order(:rank_id).order(:year).group_by{|n| n.year}}
      else
        format.html {redirect_to @award_category, flash:{error: "Nominee was not added"}}
        format.js { render partial: 'shared/errors', locals: {entity: @nominee} }
      end
    end
  end

  # PATCH/PUT /nominees/1
  # PATCH/PUT /nominees/1.json
  def update
    @award_category = @nominee.award_category
    respond_to do |format|
      if @nominee.update(nominee_params)
        format.html { redirect_to @nominee.award_category, notice: 'Nominee was successfully updated.' }
        format.json { render :show, status: :ok, location: @nominee }
        format.js {@nominees = @award_category.nominees.order(:rank_id).order(:year).group_by{|n| n.year}}
      else
        format.html { render :edit }
        format.json { render json: @nominee.errors, status: :unprocessable_entity }
        format.js { render partial: 'shared/errors', locals: {entity: @nominee} }
      end
    end
  end

  # DELETE /nominees/1
  # DELETE /nominees/1.json
  def destroy
    @nominee.destroy
    respond_to do |format|
      format.html { redirect_to nominees_url, notice: 'Nominee was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def get_nominee
    industry = AwardCategory.friendly.find(params[:award_category_id]).award.industry
    artists = industry.artists.where('artists.profile_name ILIKE ?', "%#{params[:term]}%") #TODO: tighten this query
    entities = case industry.name
    when "Art and Design"
      PhotoArt.where('title ILIKE ?', "%#{params[:term]}%")
    when "Fashion"
      PhotoArt.where('title ILIKE ?', "%#{params[:term]}%")
    when "Film, TV and Theater"
      Production.where('title ILIKE ?', "%#{params[:term]}%")
    when "Literature"
      Book.where('title ILIKE ?', "%#{params[:term]}%")
    when "Music"
      Song.where('title ILIKE ?', "%#{params[:term]}%")
    end

    nominees = artists + entities

    render :json => nominees.map { |entity_name| {:id => entity_name.id, :label => entity_name.title, :value => entity_name.title} }
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_nominee
      @nominee = Nominee.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def nominee_params
      params.require(:nominee).permit(:award_id, :nominee_name, :year, :rank_id)
    end
end
