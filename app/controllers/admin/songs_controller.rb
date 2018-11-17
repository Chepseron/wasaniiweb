class Admin::SongsController < Admin::AdminController
  before_action :set_song, only: [:show, :change_status]

  def index
    @songs = if current_admin.content_administrator?
      artists = current_admin.industries.collect{|industry| industry.artists}.flatten!.uniq
      artists.map(&:songs).flatten
    else
      Song.all
    end
  end

  def change_status
    respond_to do |format|
      case params[:status]
      when 'unpublish'
        if @song.unpublish!
          format.html { redirect_to polymorphic_path([:admin, @song]), notice: 'song was successfully unpublish.' }
          format.json { render :show, status: :ok, location: @song }
          format.js { render partial: 'admin/shared/change_entity_status',locals: {entity: @song }}
        else
          format.html { redirect_to polymorphic_path([:admin, @song]), notice: 'song was not successfully unpublish.' }
          format.json { render :show, status: :ok, location: @song }
          format.js {render partial: 'shared/errors', locals: {entity: @song }}
        end
      when 'publish'
        if @song.approve!
          format.html { redirect_to polymorphic_path([:admin, @song]), notice: 'song was successfully edited.' }
          format.json { render :show, status: :ok, location: @song }
          format.js { render partial: 'admin/shared/change_entity_status',locals: {entity: @song }}
        else
          format.html { redirect_to polymorphic_path([:admin, @song]), notice: 'song was not successfully edited.' }
          format.json { render :show, status: :ok, location: @song }
          format.js {render partial: 'shared/errors', locals: {entity: @song }}
        end
      else
        format.html { redirect_to polymorphic_path([:admin, @song]), notice: 'song was not successfully updated.' }
        format.json { render :show, status: :ok, location: @song }
        format.js {render partial: 'shared/errors', locals: {entity: @song }}
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_song
      @song = Song.friendly.find(params[:id])
    end
end
