class Admin::ProductionsController < Admin::AdminController
  before_action :set_production, only: [:show, :change_status, :edit, :update]

  def index
    @productions = if current_admin.content_administrator?
      artists = current_admin.industries.collect{|industry| industry.artists}.flatten!.uniq
      artists.map(&:productions).flatten
    else
      Production.all
    end
  end

  def update
    respond_to do |format|
      if @production.update(production_params)

        format.html { redirect_to admin_production_path(@production), notice: 'Production was successfully updated.' }
        format.json { render :show, status: :ok, location: @production }
        format.js { render :update}
      else
        format.html { render :edit }
        format.js { render partial: 'shared/errors', locals: {entity: @production} }
      end
    end
  end

  def change_status
    respond_to do |format|
      case params[:status]
      when 'unpublish'
        if @production.unpublish!
          format.html { redirect_to polymorphic_path([:admin, @production]), notice: 'production was successfully unpublish.' }
          format.json { render :show, status: :ok, location: @production }
          format.js { render partial: 'admin/shared/change_entity_status',locals: {entity: @production }}
        else
          format.html { redirect_to polymorphic_path([:admin, @production]), notice: 'production was not successfully unpublish.' }
          format.json { render :show, status: :ok, location: @production }
          format.js {render partial: 'shared/errors', locals: {entity: @production }}
        end
      when 'publish'
        if @production.approve!
          format.html { redirect_to polymorphic_path([:admin, @production]), notice: 'production was successfully edited.' }
          format.json { render :show, status: :ok, location: @production }
          format.js { render partial: 'admin/shared/change_entity_status',locals: {entity: @production }}
        else
          format.html { redirect_to polymorphic_path([:admin, @production]), notice: 'production was not successfully edited.' }
          format.json { render :show, status: :ok, location: @production }
          format.js {render partial: 'shared/errors', locals: {entity: @production }}
        end
      else
        format.html { redirect_to polymorphic_path([:admin, @production]), notice: 'production was not successfully updated.' }
        format.json { render :show, status: :ok, location: @production }
        format.js {render partial: 'shared/errors', locals: {entity: @production }}
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_production
      @production = Production.friendly.find(params[:id])
    end

    def production_params
      params.require(:production).permit(:cover_picture, :retained_cover_picture, :type_id, :cast_id_tags,
        :title, :country, :language_name, :running_time, :release_date, :synopsis, :director_id_tags,
        :production_company_id_tags, :trailer_url, :parent_id, :parent_type, :production_category_id)
    end
end
