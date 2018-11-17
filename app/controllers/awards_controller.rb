class AwardsController < ApplicationController
  skip_before_action :require_login, only: [:show, :show_awards_categories, :awards_dashboard, :awards_listings]
  before_action :set_award, only: [:show, :edit, :update, :destroy, :show_awards_categories]
  before_action :load_parent, only: [:new, :create]

  # GET /awards
  # GET /awards.json
  def index
    @awards = Award.all
  end

  def awards_dashboard
    @arts = Industry.find(1).awards.last(10)
    @fashion = Industry.find(2).awards.last(10)
    @films = Industry.find(3).awards.last(10)
    @literatures = Industry.find(4).awards.last(10)
    @musics = Industry.find(5).awards.last(10)

    @category_count = {
      'arts_awards' => @arts.count,
      'fashion_awards' => @fashion.count,
      'film_awards' => @films.count,
      'literature_awards'=> @literatures.count ,
      'music-awards' => @musics.count    
    }
  end

  def awards_listings
    @search_letter = params[:search_letter]
    @locale = params[:locale] || 'local'
    @request_path = request.path

    if params[:industry].present?
      @industry = params[:industry];
      @items = if @industry == "arts_awards"
        Industry.find(1).awards
      elsif @industry == "fashion_awards"
        Industry.find(2).awards
      elsif @industry == "film_awards"
        Industry.find(3).awards
      elsif @industry == 'music-awards'
        Industry.find(5).awards
      end 
    elsif params[:search_letter].present?
      @items = Award.where('name LIKE ?', "#{params[:search_letter]}%")
    else
      @arts = Industry.find(1).awards.last(10)
      @fashion = Industry.find(2).awards.last(10)
      @films = Industry.find(3).awards.last(10)
      @literatures = Industry.find(4).awards.last(10)
      @musics = Industry.find(5).awards.last(10)

      render 'awards_dashboard'
    end
  end

  # GET /awards/1
  # GET /awards/1.json
  def show
    @year = params[:year] || 1.year.ago.year
    @nominees = @award.nominees.where(rank_id: Rank.find_by_name('Winner').id).where(year: @year)
    @description = ActionView::Base.full_sanitizer.sanitize(@award.details).split(/\s+/).slice(0,300).join(' ');
    if policy(@award.business).update?
      @news_events_blogs = (@award.news_stories + @award.blogs + @award.events).sort_by(&:created_at).reverse
      @gallery_photos = @award.gallery_photos
    else
      @news_events_blogs = (@award.news_stories.viewable + @award.blogs.viewable + @award.events.viewable).sort_by(&:created_at).reverse
      @gallery_photos = @award.gallery_photos.viewable
    end

    respond_to do |format|
      format.html
      format.js
    end
  end

  def show_awards_categories
    @year = params[:year] || 1.year.ago.year
    @award_categories = @award.award_categories

    respond_to do |format|
      format.html
      format.js
    end
  end

  # GET /awards/new
  def new
    @award = @parent.awards.build
  end

  # GET /awards/1/edit
  def edit
  end

  # POST /awards
  # POST /awards.json
  def create
    @award = @parent.awards.build(award_params)

    respond_to do |format|
      if @award.save
        format.html { redirect_to @award, notice: 'Award was successfully created.' }
        format.json { render :show, status: :created, location: @award }
      else
        flash.now[:alert] = @award.errors.full_messages
        format.html { render :new }
        format.json { render json: @award.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /awards/1
  # PATCH/PUT /awards/1.json
  def update
    respond_to do |format|
      if @award.update(award_params)
        format.html { redirect_to @award, notice: 'Award was successfully updated.' }
        format.json { render :show, status: :ok, location: @award }
      else
        format.html { render :edit }
        format.json { render json: @award.errors, status: :unprocessable_entity }
      end
    end
  end

  def token_inputs
    render :json => Award.where('name ILIKE ?',"%#{params[:q]}%").as_json(only:[:id, :name])
  end

  # DELETE /awards/1
  # DELETE /awards/1.json
  def destroy
    @award.destroy
    respond_to do |format|
      format.html { redirect_to awards_url, notice: 'Award was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_award
      @award = Award.friendly.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def award_params
      params.require(:award).permit(:name, :details, :image, :retained_image, :country, :start_year, :industry_id)
    end
end
