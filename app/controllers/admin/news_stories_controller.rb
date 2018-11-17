class Admin::NewsStoriesController < Admin::AdminController
  before_action :set_news_story, only: [:show, :change_status]

  def index
    @news_stories = if current_admin.content_administrator?
      artists = current_admin.industries.collect{|industry| industry.artists}.flatten!.uniq
      businesses = current_admin.industries.collect{|industry| industry.businesses}.flatten!.uniq
      artists.map(&:news_stories).flatten + businesses.map(&:news_stories).flatten
    else
      NewsStory.all
    end
  end

  def change_status
    respond_to do |format|
      case params[:status]
      when 'unpublish'
        if @news_story.unpublish!
          format.html { redirect_to polymorphic_path([:admin, @news_story]), notice: 'news_story was successfully unpublish.' }
          format.json { render :show, status: :ok, location: @news_story }
          format.js { render partial: 'admin/shared/change_news_events_blogs_status',locals: {entity: @news_story }}
        else
          format.html { redirect_to polymorphic_path([:admin, @news_story]), notice: 'news_story was not successfully unpublish.' }
          format.json { render :show, status: :ok, location: @news_story }
          format.js {render partial: 'shared/errors', locals: {entity: @news_story }}
        end
      when 'publish'
        if @news_story.approve!
          format.html { redirect_to polymorphic_path([:admin, @news_story]), notice: 'news_story was successfully edited.' }
          format.json { render :show, status: :ok, location: @news_story }
          format.js { render partial: 'admin/shared/change_news_events_blogs_status',locals: {entity: @news_story }}
        else
          format.html { redirect_to polymorphic_path([:admin, @news_story]), notice: 'news_story was not successfully edited.' }
          format.json { render :show, status: :ok, location: @news_story }
          format.js {render partial: 'shared/errors', locals: {entity: @news_story }}
        end
      else
        format.html { redirect_to polymorphic_path([:admin, @news_story]), notice: 'news_story was not successfully updated.' }
        format.json { render :show, status: :ok, location: @news_story }
        format.js {render partial: 'shared/errors', locals: {entity: @news_story }}
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_news_story
      @news_story = NewsStory.friendly.find(params[:id])
    end
end
