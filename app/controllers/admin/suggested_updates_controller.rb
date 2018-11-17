class Admin::SuggestedUpdatesController < Admin::AdminController
  before_action :set_suggested_update, only: [:show, :change_status]

  def index
    @suggested_updates = if current_admin.content_administrator?
      artists = current_admin.industries.collect{|industry| industry.artists}.flatten!.uniq
      artists.suggested_updates
    else
      SuggestedUpdate.all
    end
  end

  def change_status
    @suggested_update.toggle!(:closed)
    redirect_to admin_artist_path(@suggested_update.parent)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_suggested_update
      @suggested_update = SuggestedUpdate.find(params[:id])
    end
end
