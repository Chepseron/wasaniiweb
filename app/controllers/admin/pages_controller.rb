class Admin::PagesController < Admin::AdminController


  # GET /admin/dashboard
  # GET /admin/dashboard.json
  def dashboard

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_admin
      @admin = Admin.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def admin_params
      params.require(:admin).permit(:name, :email, :password_digest)
    end
end
