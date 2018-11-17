class CollectionAlbumsController < ApplicationController
  skip_before_action :require_login, only: :show
  before_action :set_collection_album, only: [:show, :edit, :update, :destroy]
  before_action :load_parent, only: [:new, :create]

  # GET /collection_albums
  # GET /collection_albums.json
  def index
    @collection_albums = CollectionAlbum.all
  end

  # GET /collection_albums/1
  # GET /collection_albums/1.json
  def show
    @collection_album.impressions.create!
    @description = ActionView::Base.full_sanitizer.sanitize(@collection_album.description).split(/\s+/).slice(0,300).join(' ');
  end

  # GET /collection_albums/new
  def new
    @collection_album = @parent.collection_albums.build
  end

  # GET /collection_albums/1/edit
  def edit
  end

  # POST /collection_albums
  # POST /collection_albums.json
  def create
    @collection_album = @parent.collection_albums.build(collection_album_params)

    respond_to do |format|
      if @collection_album.save
        format.html { redirect_to @collection_album, notice: 'Collection album was successfully created.' }
        format.json { render :show, status: :created, location: @collection_album }
      else
        format.html { render :new }
        format.json { render json: @collection_album.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /collection_albums/1
  # PATCH/PUT /collection_albums/1.json
  def update
    respond_to do |format|
      if @collection_album.update(collection_album_params)
        @artist = @collection_album.parent
        @id = "collectionalbum-#{@collection_album.id}"
        format.html { redirect_to @collection_album, notice: 'Collection Album was successfully updated.' }
        format.json { render :show, status: :ok, location: @collection_album }
        format.js { render :update}
      else
        format.html { render :edit }
        format.js { render partial: 'shared/errors', locals: {entity: @collection_album} }
      end
    end
  end

  # DELETE /collection_albums/1
  # DELETE /collection_albums/1.json
  def destroy
    @collection_album.destroy
    respond_to do |format|
      format.html { redirect_to collection_albums_url, notice: 'Collection album was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_collection_album
      @collection_album = CollectionAlbum.friendly.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def collection_album_params
      params.require(:collection_album).permit(:title, :description, :parent_id, :parent_id, :album_date, :cover_pic,
      :retained_cover_pic, :parent_type, :book_id_tags, :song_id_tags, :photo_art_id_tags, :production_id_tags)
    end
end
