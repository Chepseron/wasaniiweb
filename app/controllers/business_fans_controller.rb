class BusinessFansController < ApplicationController
  before_action :set_business_fan, only: [:show, :edit, :update, :destroy]

  # GET /business_fans
  # GET /business_fans.json
  def index
    @business_fans = BusinessFan.all
  end

  # GET /business_fans/1
  # GET /business_fans/1.json
  def show
  end

  # GET /business_fans/new
  def new
    @business_fan = BusinessFan.new
  end

  # GET /business_fans/1/edit
  def edit
  end

  # POST /business_fans
  # POST /business_fans.json
  def create
    @business_fan = BusinessFan.new(business_fan_params)

    respond_to do |format|
      if @business_fan.save
        format.html { redirect_to @business_fan, notice: 'Business fan was successfully created.' }
        format.json { render :show, status: :created, location: @business_fan }
      else
        format.html { render :new }
        format.json { render json: @business_fan.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /business_fans/1
  # PATCH/PUT /business_fans/1.json
  def update
    respond_to do |format|
      if @business_fan.update(business_fan_params)
        format.html { redirect_to @business_fan, notice: 'Business fan was successfully updated.' }
        format.json { render :show, status: :ok, location: @business_fan }
      else
        format.html { render :edit }
        format.json { render json: @business_fan.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /business_fans/1
  # DELETE /business_fans/1.json
  def destroy
    @business_fan.destroy
    respond_to do |format|
      format.html { redirect_to business_fans_url, notice: 'Business fan was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_business_fan
      @business_fan = BusinessFan.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def business_fan_params
      params.require(:business_fan).permit(:business_id, :user_id)
    end
end
