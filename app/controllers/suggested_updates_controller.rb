class SuggestedUpdatesController < ApplicationController
  before_action :set_suggested_update, only: [:show, :edit, :update, :destroy]

  # GET /suggested_updates
  # GET /suggested_updates.json
  def index
    @suggested_updates = SuggestedUpdate.all
  end

  # GET /suggested_updates/1
  # GET /suggested_updates/1.json
  def show
  end

  # GET /suggested_updates/new
  def new
    @parent = if params.has_key?(:artist_id)
      Artist.friendly.find(params[:artist_id])
    else
      Business.friendly.find(params[:business_id])
    end
    @suggested_update = @parent.suggested_updates.build
  end

  # GET /suggested_updates/1/edit
  def edit
  end

  # POST /suggested_updates
  # POST /suggested_updates.json
  def create
    @parent = if params.has_key?(:artist_id)
      Artist.friendly.find(params[:artist_id])
    else
      Business.friendly.find(params[:business_id])
    end
    @suggested_update = @parent.suggested_updates.build(suggested_update_params)

    if @suggested_update.save
      render :suggested_update_created
    else
      render partial: 'shared/errors', locals: {entity: @suggested_update }
    end
  end

  # PATCH/PUT /suggested_updates/1
  # PATCH/PUT /suggested_updates/1.json
  def update
    respond_to do |format|
      if @suggested_update.update(suggested_update_params)
        format.html { redirect_to @suggested_update, notice: 'Suggested update was successfully updated.' }
        format.json { render :show, status: :ok, location: @suggested_update }
      else
        format.html { render :edit }
        format.json { render json: @suggested_update.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /suggested_updates/1
  # DELETE /suggested_updates/1.json
  def destroy
    @suggested_update.destroy
    respond_to do |format|
      format.html { redirect_to suggested_updates_url, notice: 'Suggested update was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_suggested_update
      @suggested_update = SuggestedUpdate.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def suggested_update_params
      params.require(:suggested_update).permit(:content, :parent_id, :parent_type)
    end
end
