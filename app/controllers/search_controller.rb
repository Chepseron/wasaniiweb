class SearchController < ApplicationController
  skip_before_action :require_login, only: [ :get_results,:item_listings]

  def get_results
    @results = PgSearch.multisearch(params[:search][:term]).paginate(:page => params[:page], :per_page => 10)
    render 'search'
  end

  def item_listings
    @type = params[:type]
    @locale = params[:locale] || 'local'
    @search_letter = params[:search_letter]
    @industry = params[:industry]

    @header = @industry.blank? ? @type.underscore.humanize.titlecase.pluralize  : @industry

    @results = if @type == "Event"
      if !@industry.blank?
        result = if @locale == 'local' && current_user
          Industry.find_by_name(@industry).events.published.or(Industry.find_by_name(@industry).events.verified).where('name LIKE ?', "#{params[:search_letter]}%").collect{|event| event if event.country == ISO3166::Country.find_country_by_alpha2(current_user.country).name}.compact
        else
          Industry.find_by_name(@industry).events.published.or(Industry.find_by_name(@industry).events.verified).where('name LIKE ?', "#{params[:search_letter]}%")
        end
      else
        result = if @locale == 'local' && current_user
          Event.published.or(Event.verified).where('name LIKE ?', "#{params[:search_letter]}%").collect{|event| event if event.country == ISO3166::Country.find_country_by_alpha2(current_user.country).name}.compact
        else
          Event.published.or(Event.verified).where('name LIKE ?', "#{params[:search_letter]}%")
        end
      end
    elsif @type == "NewsStory"
      result = if @locale == 'local' && current_user
        NewsStory.published.or(NewsStory.verified).where('title LIKE ?', "#{params[:search_letter]}%").collect{|event| event if event.country == ISO3166::Country.find_country_by_alpha2(current_user.country).name}.compact
      else
        NewsStory.published.or(NewsStory.verified).where('title LIKE ?', "#{params[:search_letter]}%")
      end
    end

    respond_to do |format|
      format.html
      format.js
    end

  end


end
