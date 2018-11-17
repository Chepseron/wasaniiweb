class Admin::BusinessCategoriesController < Admin::AdminController
  before_action :set_admin_business_category, only: [:show, :edit, :update, :destroy]

  # GET /admin_business_categories
  # GET /admin_business_categories.json
  def index
    @business_categories = BusinessCategory.all
  end

  # GET /admin_business_categories/1
  # GET /admin_business_categories/1.json
  def show
  end

  # GET /admin_business_categories/new
  def new
    @business_category = BusinessCategory.new
  end

  # GET /admin_business_categories/1/edit
  def edit
  end

  # POST /admin_business_categories
  # POST /admin_business_categories.json
  def create
    @business_category = BusinessCategory.new(admin_business_category_params)

    respond_to do |format|
      if @business_category.save
        format.html { redirect_to admin_business_categories_url, notice: 'Business category was successfully created.' }
        format.json { render :show, status: :created, location: @business_category }
      else
        format.html { render :new }
        format.json { render json: @business_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin_business_categories/1
  # PATCH/PUT /admin_business_categories/1.json
  def update
    respond_to do |format|
      if @business_category.update(admin_business_category_params)
        format.html { redirect_to admin_business_categories_url, notice: 'Business category was successfully updated.' }
        format.json { render :show, status: :ok, location: @business_category }
      else
        format.html { render :edit }
        format.json { render json: @business_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin_business_categories/1
  # DELETE /admin_business_categories/1.json
  def destroy
    @business_category.destroy
    respond_to do |format|
      format.html { redirect_to admin_business_categories_url, notice: 'Business category was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_admin_business_category
      @business_category = BusinessCategory.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def admin_business_category_params
      params.require(:business_category).permit(:name)
    end
end
