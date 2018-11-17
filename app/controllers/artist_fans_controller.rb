class ArtistFansController < ApplicationController
  before_action :set_artist_fan, only: [:show, :edit, :update, :destroy]

  # GET /artist_fans
  # GET /artist_fans.json
  def index
    @artist_fans = ArtistFan.all
  end

  # GET /artist_fans/1
  # GET /artist_fans/1.json
  def show
  end

  # GET /artist_fans/new
  def new
    @artist_fan = ArtistFan.new
  end

  # GET /artist_fans/1/edit
  def edit
  end

  # POST /artist_fans
  # POST /artist_fans.json
  def create
    @artist_fan = ArtistFan.new(artist_fan_params)

    respond_to do |format|
      if @artist_fan.save
        format.html { redirect_to @artist_fan, notice: 'Artist fan was successfully created.' }
        format.json { render :show, status: :created, location: @artist_fan }
      else
        format.html { render :new }
        format.json { render json: @artist_fan.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /artist_fans/1
  # PATCH/PUT /artist_fans/1.json
  def update
    respond_to do |format|
      if @artist_fan.update(artist_fan_params)
        format.html { redirect_to @artist_fan, notice: 'Artist fan was successfully updated.' }
        format.json { render :show, status: :ok, location: @artist_fan }
      else
        format.html { render :edit }
        format.json { render json: @artist_fan.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /artist_fans/1
  # DELETE /artist_fans/1.json
  def destroy
    @artist_fan.destroy
    respond_to do |format|
      format.html { redirect_to artist_fans_url, notice: 'Artist fan was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_artist_fan
      @artist_fan = ArtistFan.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def artist_fan_params
      params.require(:artist_fan).permit(:artist_id, :user_id)
    end
end
