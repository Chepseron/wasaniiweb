class Admin::AwardsController < Admin::AdminController
  before_action :set_award, only: [:show, :change_status]

  def index
    @awards = if current_admin.content_administrator?
      businesses = current_admin.industries.collect{|industry| industry.businesses}.flatten!.uniq
      businesses.map(&:awards).flatten
    else
      Award.all
    end
  end

  def change_status
    respond_to do |format|
      case params[:status]
      when 'unpublish'
        if @award.unpublish!
          format.html { redirect_to polymorphic_path([:admin, @award]), notice: 'award was successfully unpublish.' }
          format.json { render :show, status: :ok, location: @award }
        else
          format.html { redirect_to polymorphic_path([:admin, @award]), notice: 'award was not successfully unpublish.' }
          format.json { render :show, status: :ok, location: @award }
        end
      when 'publish'
        if @award.approve!
          format.html { redirect_to polymorphic_path([:admin, @award]), notice: 'award was successfully edited.' }
          format.json { render :show, status: :ok, location: @award }
        else
          format.html { redirect_to polymorphic_path([:admin, @award]), notice: 'award was not successfully edited.' }
          format.json { render :show, status: :ok, location: @award }
        end
      else
        format.html { redirect_to polymorphic_path([:admin, @award]), notice: 'award was not successfully updated.' }
        format.json { render :show, status: :ok, location: @award }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_award
      @award = Award.friendly.find(params[:id])
    end
end
