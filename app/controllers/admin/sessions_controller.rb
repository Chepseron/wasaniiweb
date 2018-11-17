class Admin::SessionsController < Admin::AdminController
  skip_before_action :require_admin_login, except: :destroy
  layout false

  def new
    redirect_to :admin_dashboard if current_admin
  end

  def create
    @admin = Admin.find_by_email(params[:sessions][:email])
    respond_to do |format|
      if @admin && @admin.authenticate(params[:sessions][:password]) && !@admin.deactivated?
          sign_in_admin(@admin)
          format.html { redirect_back_or_default(admin_dashboard_path)}
          format.json { render :show, status: :created, location: @admin }
      else
        format.html do
          flash.now[:error] = 'Unable to log you in'
          render :new
        end
        format.json { render json: @admin.errors, status: :unprocessable_entity }
      end
    end
  end


  def destroy
    session.delete(:admin_id)
    render 'new'
  end

  private
    def sign_in_admin(admin)
      session['admin_id'] = admin.id
    end
end
