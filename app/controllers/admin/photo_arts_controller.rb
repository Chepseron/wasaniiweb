class Admin::PhotoArtsController < Admin::AdminController
  before_action :set_photo_art, only: [:show, :change_status]

  def index
    @photo_arts = if current_admin.content_administrator?
      artists = current_admin.industries.collect{|industry| industry.artists}.flatten!.uniq
      artists.map(&:photo_arts).flatten
    else
      PhotoArt.all
    end
  end

  def change_status
    respond_to do |format|
      case params[:status]
      when 'unpublish'
        if @photo_art.unpublish!
          format.html { redirect_to polymorphic_path([:admin, @photo_art]), notice: 'photo_art was successfully unpublish.' }
          format.json { render :show, status: :ok, location: @photo_art }
          format.js { render partial: 'admin/shared/change_entity_status',locals: {entity: @photo_art }}
        else
          format.html { redirect_to polymorphic_path([:admin, @photo_art]), notice: 'photo_art was not successfully unpublish.' }
          format.json { render :show, status: :ok, location: @photo_art }
          format.js {render partial: 'shared/errors', locals: {entity: @photo_art }}
        end
      when 'publish'
        if @photo_art.approve!
          format.html { redirect_to polymorphic_path([:admin, @photo_art]), notice: 'photo_art was successfully edited.' }
          format.json { render :show, status: :ok, location: @photo_art }
          format.js { render partial: 'admin/shared/change_entity_status',locals: {entity: @photo_art }}
        else
          format.html { redirect_to polymorphic_path([:admin, @photo_art]), notice: 'photo_art was not successfully edited.' }
          format.json { render :show, status: :ok, location: @photo_art }
          format.js {render partial: 'shared/errors', locals: {entity: @photo_art }}
        end
      else
        format.html { redirect_to polymorphic_path([:admin, @photo_art]), notice: 'photo_art was not successfully updated.' }
        format.json { render :show, status: :ok, location: @photo_art }
        format.js {render partial: 'shared/errors', locals: {entity: @photo_art }}
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_photo_art
      @photo_art = PhotoArt.friendly.find(params[:id])
    end
end
