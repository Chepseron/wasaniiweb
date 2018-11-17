class Admin::EventsController < Admin::AdminController
  before_action :set_event, only: [:show, :change_status, :change_featured_status]

  def index
    @events = if current_admin.content_administrator?
      artists = current_admin.industries.collect{|industry| industry.artists}.flatten!.uniq
      businesses = current_admin.industries.collect{|industry| industry.businesses}.flatten!.uniq
      artists.map(&:events).flatten + businesses.map(&:events).flatten
    else
      Event.all
    end
  end

  def change_featured_status
    @event.toggle!(:featured)
    @events = Event.all
    respond_to do |format|
      format.html { redirect_to admin_event_path(@event), notice: 'Event was successfully changed.' }
      format.js
    end
  end

  def change_status
    respond_to do |format|
      case params[:status]
      when 'unpublish'
        if @event.unpublish!
          format.html { redirect_to polymorphic_path([:admin, @event]), notice: 'event was successfully unpublish.' }
          format.json { render :show, status: :ok, location: @event }
          format.js { render partial: 'admin/shared/change_news_events_blogs_status',locals: {entity: @event }}
        else
          format.html { redirect_to polymorphic_path([:admin, @event]), notice: 'event was not successfully unpublish.' }
          format.json { render :show, status: :ok, location: @event }
          format.js {render partial: 'shared/errors', locals: {entity: @event }}
        end
      when 'publish'
        if @event.approve!
          format.html { redirect_to polymorphic_path([:admin, @event]), notice: 'event was successfully edited.' }
          format.json { render :show, status: :ok, location: @event }
          format.js { render partial: 'admin/shared/change_news_events_blogs_status',locals: {entity: @event }}
        else
          format.html { redirect_to polymorphic_path([:admin, @event]), notice: 'event was not successfully edited.' }
          format.json { render :show, status: :ok, location: @event }
          format.js {render partial: 'shared/errors', locals: {entity: @event }}
        end
      else
        format.html { redirect_to polymorphic_path([:admin, @event]), notice: 'event was not successfully updated.' }
        format.json { render :show, status: :ok, location: @event }
        format.js {render partial: 'shared/errors', locals: {entity: @event }}
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.friendly.find(params[:id])
    end
end
