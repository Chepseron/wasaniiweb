class Admin::CollectionAlbumsController < Admin::AdminController
  before_action :set_collection_album, only: [:show, :change_status]

  def index
    @collection_albums = if current_admin.content_administrator?
      artists = current_admin.industries.collect{|industry| industry.artists}.flatten!.uniq
      artists.map(&:collection_albums).flatten
    else
      CollectionAlbum.all
    end
  end

  def change_status
    respond_to do |format|
      case params[:status]
      when 'unpublish'
        if @collection_album.unpublish!
          format.html { redirect_to polymorphic_path([:admin, @collection_album]), notice: 'collection_album was successfully unpublish.' }
          format.json { render :show, status: :ok, location: @collection_album }
          format.js { render partial: 'admin/shared/change_entity_status',locals: {entity: @collection_album }}
        else
          format.html { redirect_to polymorphic_path([:admin, @collection_album]), notice: 'collection_album was not successfully unpublish.' }
          format.json { render :show, status: :ok, location: @collection_album }
          format.js {render partial: 'shared/errors', locals: {entity: @collection_album }}
        end
      when 'publish'
        if @collection_album.approve!
          format.html { redirect_to polymorphic_path([:admin, @collection_album]), notice: 'collection_album was successfully edited.' }
          format.json { render :show, status: :ok, location: @collection_album }
          format.js { render partial: 'admin/shared/change_entity_status',locals: {entity: @collection_album }}
        else
          format.html { redirect_to polymorphic_path([:admin, @collection_album]), notice: 'collection_album was not successfully edited.' }
          format.json { render :show, status: :ok, location: @collection_album }
          format.js {render partial: 'shared/errors', locals: {entity: @collection_album }}
        end
      else
        format.html { redirect_to polymorphic_path([:admin, @collection_album]), notice: 'collection_album was not successfully updated.' }
        format.json { render :show, status: :ok, location: @collection_album }
        format.js {render partial: 'shared/errors', locals: {entity: @collection_album }}
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_collection_album
      @collection_album = CollectionAlbum.friendly.find(params[:id])
    end
end
