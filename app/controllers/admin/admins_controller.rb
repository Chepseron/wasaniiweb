class Admin::AdminsController < Admin::AdminController
  before_action :has_admins_controller_permissions, except: :index

  def index
    redirect_to :admin_dashboard, notice: "That's not allowed" and return unless current_admin.system_administrator?
  end
  # GET admin/admins/new
  def new
    @admin = Admin.new
  end

  # GET /admins/1/edit
  def edit
    @admin = Admin.find(params[:id])
    unless current_admin.system_administrator?
      unless @admin == current_admin
        flash.now[:error] = 'Unable to view that page'
        redirect_to admin_dashboard_path and return
      end
    end
  end

  def show
    @admin = Admin.find(params[:id])
  end

  # POST /admin/admins
  # POST /admin/admins.json
  def create
    @admin = Admin.new(admin_params)
    @password = @admin.password = @admin.password_confirmation = SecureRandom.hex(6)

    respond_to do |format|
      if @admin.save

        AdminMailer.registration_confirmation(@admin, @password).deliver

        format.html { redirect_to admin_root_path, notice: 'Admin has been added.'}
        format.json { render :show, status: :created, location: @admin }
      else
        flash[:error] = "Ooooppss, something went wrong!"
        format.html { render :new }
        format.json { render json: @admin.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @admin = @admin = Admin.find(params[:id])

    unless current_admin.system_administrator?
      unless @admin == current_admin
        flash.now[:error] = 'Unable to view that page'
        redirect_to admin_dashboard_path and return
      end
    end

    respond_to do |format|
      if @admin.update(admin_params)
        format.html { redirect_to admin_admin_path(@admin), notice: 'Admin was successfully updated.' }
        format.json { render :show, status: :ok, location: @admin }
      else
        format.html { render :edit }
        format.json { render json: @admin.errors, status: :unprocessable_entity }
      end
    end
  end

  def reset_password
    @admin = Admin.find(params[:id])
    @admin.password = SecureRandom.hex(6)
    respond_to do |format|
      if @admin.save
        AdminMailer.reset_password(@admin, @admin.password).deliver
        flash.now[:notice] = 'Password Successfully changed and email sent to admin'
        format.js { render partial: 'layouts/messages'}
      else
        format.js { render partial: 'shared/errors', locals: {entity: @admin} }
      end
    end

  end

  def activate_deactivate
    redirect_to :admin_admins, notice: "That's not allowed" and return unless current_admin.system_administrator?
    @admin = Admin.find(params[:id])
    @admin.toggle!(:deactivated)
    redirect_to admin_admin_path(@admin), notice: "Admin was successfully updated."
  end

  private
    def admin_params
      params.require(:admin).permit(:name, :email, :password, :password_confirmation, :admin_role_id, industry_ids:[])
    end

end
