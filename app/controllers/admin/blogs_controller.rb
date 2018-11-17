class Admin::BlogsController < Admin::AdminController
  before_action :set_blog, only: [:show, :change_status]

  def index
    @blogs = if current_admin.content_administrator?
      artists = current_admin.industries.collect{|industry| industry.artists}.flatten!.uniq
      businesses = current_admin.industries.collect{|industry| industry.businesses}.flatten!.uniq
      artists.map(&:blogs).flatten + businesses.map(&:blogs).flatten
    else
      Blog.all
    end
  end

  def change_status
    respond_to do |format|
      case params[:status]
      when 'unpublish'
        if @blog.unpublish!
          format.html { redirect_to polymorphic_path([:admin, @blog]), notice: 'blog was successfully unpublish.' }
          format.json { render :show, status: :ok, location: @blog }
          format.js { render partial: 'admin/shared/change_news_events_blogs_status',locals: {entity: @blog }}
        else
          format.html { redirect_to polymorphic_path([:admin, @blog]), notice: 'blog was not successfully unpublish.' }
          format.json { render :show, status: :ok, location: @blog }
          format.js {render partial: 'shared/errors', locals: {entity: @blog }}
        end
      when 'publish'
        if @blog.approve!
          format.html { redirect_to polymorphic_path([:admin, @blog]), notice: 'blog was successfully edited.' }
          format.json { render :show, status: :ok, location: @blog }
          format.js { render partial: 'admin/shared/change_news_events_blogs_status',locals: {entity: @blog }}
        else
          format.html { redirect_to polymorphic_path([:admin, @blog]), notice: 'blog was not successfully edited.' }
          format.json { render :show, status: :ok, location: @blog }
          format.js {render partial: 'shared/errors', locals: {entity: @blog }}
        end
      else
        format.html { redirect_to polymorphic_path([:admin, @blog]), notice: 'blog was not successfully updated.' }
        format.json { render :show, status: :ok, location: @blog }
        format.js {render partial: 'shared/errors', locals: {entity: @blog }}
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_blog
      @blog = Blog.friendly.find(params[:id])
    end
end
