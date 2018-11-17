class LifeEventsController < ApplicationController
  skip_before_action :require_login, only: :show
  before_action :set_life_event, only: [:show, :edit, :update, :destroy, :publish]
  before_action :load_parent, only: [:new, :create]
  # GET /life_events
  # GET /life_events.json
  def index
    @life_events = LifeEvent.all
  end

  # GET /life_events/1
  # GET /life_events/1.json
  def show
    @artist = @life_event.parent
    @life_event.impressions.create!
  end

  # GET /life_events/new
  def new
    @life_event = @parent.life_events.build
  end

  # GET /life_events/1/edit
  def edit
    @artist = @life_event.parent
  end

  # POST /life_events
  # POST /life_events.json
  def create
    @life_event = @parent.life_events.build(life_event_params)

    respond_to do |format|
      if @life_event.save
        add_gallery_photos(@life_event, params[:images]) if params[:images]

        format.html { redirect_to @life_event, notice: 'Life event was successfully created.' }
        format.json { render :show, status: :created, location: @life_event }
      else
        format.html { render :new }
        format.json { render json: @life_event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /life_events/1
  # PATCH/PUT /life_events/1.json
  def update
    respond_to do |format|
      if @life_event.update(life_event_params)
        add_gallery_photos(@life_event, params[:images]) if params[:images]
        @artist = @life_event.parent

        format.html { redirect_to @life_event, notice: 'Life event was successfully updated.' }
        format.json { render :show, status: :ok, location: @life_event }
        format.js {render :update }
      else
        format.html { render :edit }
        format.json { render json: @life_event.errors, status: :unprocessable_entity }
        format.js {render partial: 'shared/errors', locals: {entity: @life_event }}
      end
    end
  end

  # DELETE /life_events/1
  # DELETE /life_events/1.json
  def destroy
    @life_event.destroy
    respond_to do |format|
      format.html { redirect_to life_events_url, notice: 'Life event was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def publish
    @life_event.publish!
    redirect_to @life_event
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_life_event
      @life_event = LifeEvent.friendly.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def life_event_params
      params.require(:life_event).permit(:date, :title, :description, :duration, :parent_id, :image, :retained_image,
      :parent_type, :life_event_category_id, :book_id_tags, :production_id_tags, :song_id_tags, :photo_art_id_tags,
      :collection_album_id_tags, :award_id_tags)
    end
end
