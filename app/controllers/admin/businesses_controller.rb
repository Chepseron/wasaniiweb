class Admin::BusinessesController < Admin::AdminController
  before_action :set_business, only: [:show, :edit, :update, :ban, :destroy, :verify,
    :change_featured_status, :invite_page_admin, :send_admin_invitation,
    :request_ownership_transfer, :transfer_ownership]

  # GET /businesses
  # GET /businesses.json
  def index
    @businesses = if current_admin.content_administrator?
      current_admin.industries.collect{|industry| industry.businesses}.flatten!.uniq
    else
      Business.all
    end
  end

  # GET /businesses/1
  # GET /businesses/1.json
  def show
    @news_events_blogs = @business.news_stories + @business.events  + @business.blogs
  end

  # GET /businesses/new
  def new
    @business = current_admin.businesses.build
  end

  # GET /businesses/1/edit
  def edit
  end

  def create_entity
    @entity = if params.has_key? :book
      @business.books.build(book_params)
    elsif params.has_key? :song
      @business.songs.build(song_params)
    elsif params.has_key? :photo_art
      @business.photo_arts.build(photo_art_params)
    elsif params.has_key? :production
      @business.productions.build(production_params)
    elsif params.has_key? :collection_album
      @business.collection_albums.build(collection_album_params)
    end

    if @entity.save
      add_gallery_photos(@entity, params[:images]) if params[:images]
      render :update_entities
    else
      render partial: 'shared/errors', locals: {entity: @entity }
    end
  end

  # POST /businesses
  # POST /businesses.json
  def create
    @business = current_admin.businesses.build(business_params)

    respond_to do |format|
      if @business.save
        format.html { redirect_to admin_business_url(@business), notice: 'Business was successfully created.' }
        format.json { render :show, status: :created, location: @business }
      else
        format.html { render :new }
        format.json { render json: @business.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /businesses/1
  # PATCH/PUT /businesses/1.json
  def update
    respond_to do |format|
      if @business.update(business_params)
        format.html { redirect_to admin_business_url(@business), notice: 'Business was successfully updated.' }
        format.json { render :show, status: :ok, location: @business }
      else
        format.html { render :edit }
        format.json { render json: @business.errors, status: :unprocessable_entity }
      end
    end
  end

  def ban
    @business.toggle!(:banned)
    redirect_to admin_business_path(@business)
  end

  def verify
    respond_to do |format|
      if @business.toggle!(:verified)
        format.html { redirect_to admin_businesses_path(@business),notice: 'Business was successfully verified.' }
      else
        format.html { redirect_to admin_businesses_path(@business),notice: 'Business was not verified.' }
      end
    end
  end

  def change_featured_status
    @business.toggle!(:featured)
    @businesses = Business.all
    respond_to do |format|
      format.html { redirect_to admin_business_path(@business), notice: 'Business was successfully changed.' }
      format.js
    end
  end

  def send_admin_invitation
    if params[:invitation][:email_address].blank?
      flash[:error] = 'Please enter an email address'
      redirect_to admin_business_path(@business) and return
    end

    @user = User.find_by_email params[:invitation][:email_address]
    if @user.nil?
      @user = User.new(email: params[:invitation][:email_address])
      @user.save!(validate: false)
    end

    respond_to do |format|
      if @user.is_page_admin?(@business)
        @user.send_admin_invitation(@business)
        format.html { redirect_to admin_business_path(@business), notice: 'The user selected is already an admin' }
        format.json { render :show, status: :ok, location: @business }
      elsif @user.add_as_page_admin(@business)
        format.html { redirect_to admin_business_path(@business), notice: 'A new admin was successfully invited' }
        format.json { render :show, status: :ok, location: @business }
      end
    end
  end

  def transfer_ownership
    if params[:transfer_ownership][:new_owner].blank?
      flash[:error] = 'Please select a valid selection'
      redirect_to admin_business_path(@business) and return
    end

    @new_owner = User.find(params[:transfer_ownership][:new_owner])
    old_owner = @business.parent
    @business.parent = @new_owner
    respond_to do |format|
      if @business.save
        old_owner.add_as_page_admin(@business)
        format.html { redirect_to admin_business_path(@business), notice: "Ownership has been transferred to #{@new_owner.name}." }
        format.json { head :no_content }
      end
    end
  end

  # DELETE /businesses/1
  # DELETE /businesses/1.json
  def destroy
    @business.destroy
    respond_to do |format|
      format.html { redirect_to admin_businesses_url, notice: 'Business was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_business
      @business = Business.friendly.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def business_params
      params.require(:business).permit(:name, :logo, :retained_logo, :country, :latitude,
      :longitude, :business_category_id, :company_info, :verified, :physical_location, :phone_number,
      :email, :working_hours, industry_ids: [])
    end
end
