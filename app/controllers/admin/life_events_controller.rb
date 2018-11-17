class Admin::LifeEventsController < Admin::AdminController
  before_action :set_life_event, only: [:show, :change_status]

  def index
    @life_events = if current_admin.content_administrator?
      artists = current_admin.industries.collect{|industry| industry.artists}.flatten!.uniq
      artists.map(&:life_events).flatten
    else
      LifeEvent.all
    end
  end

  def change_status
    @artist = @life_event.parent
    respond_to do |format|
      case params[:status]
      when 'unpublish'
        if @life_event.unpublish!
          format.html { redirect_to polymorphic_path([:admin, @life_event]), notice: 'life_event was successfully unpublish.' }
          format.json { render :show, status: :ok, location: @life_event }
          format.js { render partial: 'change_status',locals: {entity: @life_event }}
        else
          format.html { redirect_to polymorphic_path([:admin, @life_event]), notice: 'life_event was not successfully unpublish.' }
          format.json { render :show, status: :ok, location: @life_event }
          format.js {render partial: 'shared/errors', locals: {entity: @life_event }}
        end
      when 'publish'
        if @life_event.approve!
          format.html { redirect_to polymorphic_path([:admin, @life_event]), notice: 'life_event was successfully edited.' }
          format.json { render :show, status: :ok, location: @life_event }
          format.js { render partial: 'change_status',locals: {entity: @life_event }}
        else
          format.html { redirect_to polymorphic_path([:admin, @life_event]), notice: 'life_event was not successfully edited.' }
          format.json { render :show, status: :ok, location: @life_event }
          format.js {render partial: 'shared/errors', locals: {entity: @life_event }}
        end
      else
        format.html { redirect_to polymorphic_path([:admin, @life_event]), notice: 'life_event was not successfully updated.' }
        format.json { render :show, status: :ok, location: @life_event }
        format.js {render partial: 'shared/errors', locals: {entity: @life_event }}
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_life_event
      @life_event = LifeEvent.friendly.find(params[:id])
    end

    def life_event_params
      params.require(:life_event).permit(:date, :title, :description, :duration, :parent_id, :image, :retained_image,
      :parent_type, :life_event_category_id, book_ids:[], production_ids:[], song_ids:[], photo_art_ids:[])
    end
end
