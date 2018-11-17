class GalleryPhotosController < ApplicationController
  skip_before_action :require_login, only: :show
  before_action :set_gallery_photo, only: [:show, :edit, :update, :destroy]
  before_action :load_parent, only: [:new, :create]

  # GET /gallery_photos
  # GET /gallery_photos.json
  def index
    @gallery_photos = GalleryPhoto.all
  end

  # GET /gallery_photos/1
  # GET /gallery_photos/1.json
  def show
  end

  # GET /gallery_photos/new
  def new
    @gallery_photo = @parent.gallery_photos.build
  end

  # GET /gallery_photos/1/edit
  def edit
  end

  # POST /gallery_photos
  # POST /gallery_photos.json
  def create
    @gallery_photo = @parent.gallery_photos.build(gallery_photo_params)

    respond_to do |format|
      if @gallery_photo.save
        @gallery_photos = @parent.gallery_photos
        format.html { redirect_to @gallery_photos, notice: 'GalleryPhoto was successfully created.' }
        format.json { render :show, status: :created, location: @gallery_photo }
        format.js 
      else
        format.html { render :new }
        format.json { render json: @gallery_photo.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /gallery_photos/1
  # PATCH/PUT /gallery_photos/1.json
  def update
    respond_to do |format|
      if @gallery_photo.update(gallery_photo_params)
        format.html { redirect_to @gallery_photo, notice: 'GalleryPhoto was successfully updated.' }
        format.json { render :show, status: :ok, location: @gallery_photo }
      else
        format.html { render :edit }
        format.json { render json: @gallery_photo.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /gallery_photos/1
  # DELETE /gallery_photos/1.json
  def destroy
    @gallery_photo.destroy
    respond_to do |format|
      format.html { redirect_to :back, notice: 'GalleryPhoto was successfully destroyed.' }
      format.json { head :no_content }
      format.js do

      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_gallery_photo
      @gallery_photo = GalleryPhoto.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def gallery_photo_params
      params.require(:gallery_photo).permit(:image, :retained_image, :caption, :parent_type, :parent_id)
    end
end
