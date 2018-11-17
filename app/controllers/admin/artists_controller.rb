class Admin::ArtistsController < Admin::AdminController
  before_action :set_artist, only: [:show, :edit, :update, :change_status, :change_featured_status, :verify,
    :invite_page_admin, :send_admin_invitation, :request_ownership_transfer, :transfer_ownership]

  def index
    @artists = if current_admin.content_administrator?
      current_admin.industries.collect{|industry| industry.artists}.flatten!.uniq
    else
      Artist.all.paginate(:page => params[:page], :per_page => 10)
    end
  end

  def show
    @entities = @artist.works
    @news_events_blogs = @artist.news_stories + @artist.events + @artist.blogs

    @managing_users = ([@artist.parent] + @artist.managing_users).flatten.uniq
  end

  def update
    respond_to do |format|
      if @artist.update(artist_params)
        if @artist.previous_changes.empty?
          @artist.approve!
        else
          @previous_changes = @artist.previous_changes
          @artist.approve_with_changes!
        end

        format.html { redirect_to admin_artist_path(@artist), notice: 'Artist was successfully updated.' }
        format.json { render :show, status: :ok, location: @artist }
        format.js { render :update}
      else
        format.html { render :edit }
        format.json { render json: @artist.errors, status: :unprocessable_entity }
      end
    end
  end

  def send_admin_invitation
    if params[:invitation][:email_address].blank?
      flash[:error] = 'Please enter an email address'
      redirect_to admin_artist_path(@artist) and return
    end

    @user = User.find_by_email params[:invitation][:email_address]

    if @user.nil?
      @user = User.new(email: params[:invitation][:email_address])
      @user.save!(validate: false)
    end

    respond_to do |format|
      if @user.is_page_admin?(@artist)
        @user.send_admin_invitation(@artist)
        format.html { redirect_to admin_artist_path(@artist), notice: 'The user selected is already an admin' }
        format.json { render :show, status: :ok, location: @artist }
      elsif @user.add_as_page_admin(@artist)
        format.html { redirect_to admin_artist_path(@artist), notice: 'A new admin was successfully invited' }
        format.json { render :show, status: :ok, location: @artist }
      end
    end
  end

  def transfer_ownership
    if params[:transfer_ownership][:new_owner].blank?
      flash[:error] = 'Please select a valid selection'
      redirect_to admin_artist_path(@artist) and return
    end

    @new_owner = User.find(params[:transfer_ownership][:new_owner])
    old_owner = @artist.parent
    @artist.parent = @new_owner
    respond_to do |format|
      if @artist.save
        old_owner.add_as_page_admin(@artist)
        format.html { redirect_to admin_artist_path(@artist), notice: "Ownership has been transferred to #{@new_owner.name}." }
        format.json { head :no_content }
      end
    end
  end

  def change_featured_status
    @artist.toggle!(:featured)
    @artists = Artist.all
    respond_to do |format|
      format.html { redirect_to admin_artist_path(@artist), notice: 'Artist was successfully changed.' }
      format.js
    end
  end

  def verify
    @artist.toggle!(:verified)
    redirect_to admin_artist_path(@artist)
  end

  def change_status
    respond_to do |format|
      case params[:status]
      when 'approve'
        if @artist.approve!
          format.html { redirect_to admin_artist_path(@artist), notice: 'Artist was successfully published.' }
          format.json { render :show, status: :ok, location: @artist }
        else
          format.html { redirect_to admin_artist_path(@artist), notice: 'Artist was not successfully updated.' }
          format.json { render :show, status: :ok, location: @artist }
        end
      when 'unpublish'
        if @artist.unpublish!
          format.html { redirect_to admin_artist_path(@artist), notice: 'Artist was successfully unpublish.' }
          format.json { render :show, status: :ok, location: @artist }
        else
          format.html { redirect_to admin_artist_path(@artist), notice: 'Artist was not successfully updated.' }
          format.json { render :show, status: :ok, location: @artist }
        end
      else
        format.html { redirect_to admin_artist_path(@artist), notice: 'Artist was not successfully updated.' }
        format.json { render :show, status: :ok, location: @artist }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_artist
      @artist = Artist.friendly.find(params[:id])
    end

    def artist_params
      params.require(:artist).permit(:profile_name, :name, :gender, :birthday,
      :country_of_birth, :profile_pic, :retained_profile_pic, :speciality, :introduction,
      :verified, :contact_phone_number, :contact_email, :height, :weight, :bust,
      :hips, :parent_type, :parent_id, :industry_ids=>[], :artist_speciality_ids=>[])
    end
end
