class AwardCategoriesController < ApplicationController
  before_action :set_award_category, only: [:show, :edit, :update, :destroy]
  before_action :load_parent, only: [:index, :new, :create]

  # GET /award_categories
  # GET /award_categories.json
  def index
    @award = @parent
    @award_categories = @award.award_categories
  end

  # GET /award_categories/1
  # GET /award_categories/1.json
  def show
    @award = @award_category.award
    @nominees = @award_category.nominees.order(:rank_id).order(:year).group_by{|n| n.year}
  end

  # GET /award_categories/new
  def new
    @award = @parent
    @award_category = @award.award_categories.build
    render 'new_category'
  end

  # GET /award_categories/1/edit
  def edit
    render 'edit_category'
  end

  # POST /award_categories
  # POST /award_categories.json
  def create
    @award = @parent
    @award_category = @award.award_categories.build(award_category_params)
    @award_categories = @award.award_categories
    respond_to do |format|
      if @award_category.save
        format.html { redirect_to award_award_categories_path(@award), notice: 'Award category was successfully created.' }
        format.json { render :show, status: :created, location: @award_category }
        format.js
      else
        format.html { render :new }
        format.json { render json: @award_category.errors, status: :unprocessable_entity }
        format.js { render partial: 'shared/errors', locals: {entity: @award_category} }
      end
    end
  end

  # PATCH/PUT /award_categories/1
  # PATCH/PUT /award_categories/1.json
  def update
    @award_categories = @award_category.award.award_categories
    respond_to do |format|
      if @award_category.update(award_category_params)
        format.html { redirect_to award_award_categories_path(@award_category.award), notice: 'Award category was successfully updated.' }
        format.json { render :show, status: :ok, location: @award_category }
        format.js
      else
        format.html { render :edit }
        format.json { render json: @award_category.errors, status: :unprocessable_entity }
        format.js { render partial: 'shared/errors', locals: {entity: @award_category} }
      end
    end
  end

  # DELETE /award_categories/1
  # DELETE /award_categories/1.json
  def destroy
    @award_category.destroy
    respond_to do |format|
      format.html { redirect_to award_categories_url, notice: 'Award category was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_award_category
      @award_category = AwardCategory.friendly.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def award_category_params
      params.require(:award_category).permit(:name, :award_id, :accepts_entity)
    end
end
