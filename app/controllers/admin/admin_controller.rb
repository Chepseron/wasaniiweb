class Admin::AdminController < ApplicationController
  skip_before_action :require_login
  before_action :require_admin_login

  layout 'admin'

  def has_admins_controller_permissions
    admin = Admin.find_by_id(params[:id])
    unless current_admin.system_administrator? || current_admin == admin
      flash[:error] = "You don't have sufficient permission to view that page"
      redirect_to admin_root_path and return
    end
  end

  def require_admin_login
    redirect_to '/admin' unless current_admin
  end
end
