class Admin::GalleryPhotosController < Admin::AdminController
  before_action :set_gallery_photo, only: [:show, :change_status]
  before_action :set_gallery_photo, only: [:show, :edit, :update, :destroy]
  protect_from_forgery :except => [:create]

  # GET /gallery_photos
  # GET /gallery_photos.json
  def index
    @gallery_photos = if current_admin.content_administrator?
      artists = current_admin.industries.collect{|industry| industry.artists}.flatten.uniq
      businesses = current_admin.industries.collect{|industry| industry.businesses}.flatten.uniq
      awards = businesses.map(&:awards).flatten.uniq
      collection_albums = artists.map(&:collection_albums).flatten.uniq
      blogs = (artists.map(&:blogs).flatten.uniq + businesses.map(&:blogs).flatten.uniq).flatten.uniq
      events = (artists.map(&:events).flatten.uniq + businesses.map(&:events).flatten.uniq).flatten.uniq
      news_stories = (artists.map(&:news_stories).flatten.uniq + businesses.map(&:news_stories).flatten.uniq).flatten.uniq

      (artists.map(&:gallery_photos).flatten + businesses.map(&:gallery_photos).flatten +
      awards.map(&:gallery_photos).flatten + collection_albums.map(&:gallery_photos).flatten +
      blogs.map(&:gallery_photos).flatten + events.map(&:gallery_photos).flatten +
      news_stories.map(&:gallery_photos).flatten).sort_by(&:created_at).reverse
    else
      GalleryPhoto.all
    end
  end

  def change_status
    respond_to do |format|
      case params[:status]
      when 'unpublish'
        @gallery_photo = GalleryPhoto.find(params[:id])
        @gallery_photo.aasm_state = "unpublished"
        if @gallery_photo.save!
          format.html { redirect_to polymorphic_path([:admin, @gallery_photo]), notice: 'gallery_photo was successfully unpublish.' }
          format.json { render :show, status: :ok, location: @gallery_photo }
          format.js { render partial: 'change_status',locals: {entity: @gallery_photo }}
        else
          format.html { redirect_to polymorphic_path([:admin, @gallery_photo]), notice: 'gallery_photo was not successfully unpublish.' }
          format.json { render :show, status: :ok, location: @gallery_photo }
          format.js {render partial: 'shared/errors', locals: {entity: @gallery_photo }}
        end
      when 'publish'
        @gallery_photo = GalleryPhoto.find(params[:id])
        @gallery_photo.aasm_state = "published"
        if @gallery_photo.save!
          format.html { redirect_to polymorphic_path([:admin, @gallery_photo]), notice: 'gallery_photo was successfully edited.' }
          format.json { render :show, status: :ok, location: @gallery_photo }
          format.js { render partial: 'change_status',locals: {entity: @gallery_photo }}
        else
          format.html { redirect_to polymorphic_path([:admin, @gallery_photo]), notice: 'gallery_photo was not successfully edited.' }
          format.json { render :show, status: :ok, location: @gallery_photo }
          format.js {render partial: 'shared/errors', locals: {entity: @gallery_photo }}
        end
      else
        format.html { redirect_to polymorphic_path([:admin, @gallery_photo]), notice: 'gallery_photo was not successfully updated.' }
        format.json { render :show, status: :ok, location: @gallery_photo }
        format.js {render partial: 'shared/errors', locals: {entity: @gallery_photo }}
      end
    end
  end

  def create
    @parent = Business.find(params[:biz])
    @gallery_photo = @parent.gallery_photos.build(gallery_photo_params)

    respond_to do |format|
      if @gallery_photo.save
        @gallery_photos = @parent.gallery_photos
        format.html { redirect_to admin_business_path(@parent), notice: 'GalleryPhoto was successfully created.' }
        format.json { render :show, status: :created, location: @gallery_photo }
        format.js
      else
        format.html { render :new }
        format.json { render json: @gallery_photo.errors, status: :unprocessable_entity }
      end
    end
  end

  def new
    @gallery_photo = @parent.gallery_photos.build
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_gallery_photo
      @gallery_photo = GalleryPhoto.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def gallery_photo_params
      params.require(:gallery_photo).permit(:image, :retained_image, :caption, :parent_type, :parent_id,:biz)
    end
end
