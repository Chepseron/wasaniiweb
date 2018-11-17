class Admin::UsersController < Admin::AdminController
  before_action :set_user, only: [:show, :edit, :update, :ban, :reset_password]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end


  # GET /users/1/edit
  # def edit
#   end


  # # PATCH/PUT /users/1
#   # PATCH/PUT /users/1.json
#   def update
#     respond_to do |format|
#       @user.user_role_id = params[:user][:user_role_id]
#       @user.industry_ids = params[:user][:industry_ids]
#       if @user.save
#         format.html { redirect_to admin_user_path(@user), notice: 'User was successfully updated.' }
#         format.json { render :show, status: :ok, location: @user }
#       else
#         format.html { render :edit }
#         format.json { render json: @user.errors, status: :unprocessable_entity }
#       end
#     end
#   end

  def ban
    redirect_to :admin_admins, notice: "That's not allowed" and return unless current_admin.system_administrator?
    @user.toggle!(:banned)
    redirect_to admin_user_path(@user)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.friendly.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:user_role_id, industry_ids:[])
    end
end
