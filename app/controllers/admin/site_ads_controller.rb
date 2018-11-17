class Admin::SiteAdsController < Admin::AdminController
  before_action :set_site_ad, only: [:show, :edit, :update, :destroy]

  # GET /site_ads
  # GET /site_ads.json
  def index
    @site_ads = SiteAd.all
  end

  # GET /site_ads/1
  # GET /site_ads/1.json
  def show
  end

  # GET /site_ads/new
  def new
    @site_ad = SiteAd.new
  end

  # GET /site_ads/1/edit
  def edit
  end

  # POST /site_ads
  # POST /site_ads.json
  def create
    @site_ad = SiteAd.new(site_ad_params)

    respond_to do |format|
      if @site_ad.save
        format.html { redirect_to admin_site_ad_path(@site_ad), notice: 'Site ad was successfully created.' }
        format.json { render :show, status: :created, location: @site_ad }
      else
        format.html { render :new }
        format.json { render json: @site_ad.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /site_ads/1
  # PATCH/PUT /site_ads/1.json
  def update
    respond_to do |format|
      if @site_ad.update(site_ad_params)
        format.html { redirect_to admin_site_ad_path(@site_ad), notice: 'Site ad was successfully updated.' }
        format.json { render :show, status: :ok, location: @site_ad }
      else
        format.html { render :edit }
        format.json { render json: @site_ad.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /site_ads/1
  # DELETE /site_ads/1.json
  def destroy
    @site_ad.destroy
    respond_to do |format|
      format.html { redirect_to admin_site_ads_url, notice: 'Site ad was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_site_ad
      @site_ad = SiteAd.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def site_ad_params
      params.require(:site_ad).permit(:name, :site_ad_position_id, :image, :retained_image, :script, :active)
    end
end
