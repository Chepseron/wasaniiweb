class NewsStoriesController < ApplicationController
  skip_before_action :require_login, only: :show
  before_action :set_news_story, only: [:show, :edit, :update, :destroy]
  before_action :load_parent, only: [:new, :create]
  # GET /news_stories
  # GET /news_stories.json
  def index
    @news_stories = NewsStory.all
  end

  # GET /news_stories/1
  # GET /news_stories/1.json
  def show
    @news_story.impressions.create!
    @description = ActionView::Base.full_sanitizer.sanitize(@news_story.content).split(/\s+/).slice(0,300).join(' ');
  end

  # GET /news_stories/new
  def new
    @news_story = @parent.news_stories.build
  end

  # GET /news_stories/1/edit
  def edit
  end

  # POST /news_stories
  # POST /news_stories.json
  def create
    @news_story = @parent.news_stories.build(news_story_params)

    respond_to do |format|
      if @news_story.save
        add_gallery_photos(@news_story, params[:images]) if params[:images]
        format.html { redirect_to @news_story, notice: 'News story was successfully created.' }
        format.json { render :show, status: :created, location: @news_story }
      else
        format.html { render :new }
        format.json { render json: @news_story.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /news_stories/1
  # PATCH/PUT /news_stories/1.json
  def update
    respond_to do |format|
      if @news_story.update(news_story_params)
        @id = "newsstory-#{@news_story.id}"
        @artist = @news_story.parent

        add_gallery_photos(@news_story, params[:images]) if params[:images]
        format.html { redirect_to @news_story, notice: 'News story was successfully updated.' }
        format.json { render :show, status: :ok, location: @news_story }
        format.js {render :update}
      else
        format.html { render :edit }
        format.json { render json: @news_story.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /news_stories/1
  # DELETE /news_stories/1.json
  def destroy
    @news_story.destroy
    respond_to do |format|
      format.html { redirect_to news_stories_url, notice: 'News story was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_news_story
      @news_story = NewsStory.friendly.find(params[:id])
    end


    # Never trust parameters from the scary internet, only allow the white list through.
    def news_story_params
      params.require(:news_story).permit(:title, :date, :content, :image, :retained_image,
      :parent_type, :parent_id, :artist_id_tags, :business_id_tags, :event_id_tags, :award_id_tags)
    end
end
