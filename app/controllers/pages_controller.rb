class PagesController < ApplicationController
  skip_before_action :require_login
  skip_before_action :require_more_info
  require 'mail'

  def homepage
    @artists = Artist.viewable.featured

    @new_media = (Book.viewable + Song.viewable + PhotoArt.viewable + Production.viewable + CollectionAlbum.viewable).sort_by(&:created_at).reverse
    @trending_news_blogs = (NewsStory.trending).sort_by(&:created_at).reverse
    @events = Event.published.last(10)
    Mail.defaults do
      delivery_method :smtp, {
        :port      => 587,
        :address   => "smtp.mailgun.com",
        :user_name => "noreply@wasanii.com",
        :password  => "Mediawasanii78890",
      }
    end
    

    render layout: false
  end

  def privacy
    @data = Site.find(3)
  end

  def terms_and_conditions
    @data = Site.find(1)
  end

  def help
    @data = Site.find(5)
  end

  def about
    @data = Site.find(2)
  end
end
