module ArtistsHelper
  def artist_image(artist)
    if artist.is_a? Artist
      artist.profile_pic_stored? ? artist.profile_pic.url : 'default-profile-pic.png'
    else
      artist.logo_stored? ? artist.logo.url : 'default-business-pic.png'
    end
  end

  def entity_name(entity)
    unless entity.nil?
      if entity.is_a?(Artist)
        return entity.profile_name
      elsif entity.is_a?(Event) || entity.is_a?(Business) || entity.is_a?(Award)
        return entity.name
      elsif entity.is_a?(GalleryPhoto)
        return entity.image.name
      else
        return entity.title
      end
    end
  end

  def get_date(entity)
    if entity.is_a?(Song) && entity.release_date
      return entity.release_date.strftime("%d %B %Y")
    elsif entity.is_a?(Production) && entity.release_date
      return entity.release_date.strftime("%d %B %Y")
    elsif entity.is_a?(PhotoArt) && entity.date
      return entity.date.strftime("%d %B %Y")
    elsif entity.is_a?(Book) && entity.publishing_date
      return entity.publishing_date.strftime("%d %B %Y")
    else
      return entity.created_at.strftime("%d %B %Y")
    end
  end

  def card_image(card)
    return card.image.url if card.image_stored?
    if card.is_a?(Blog)
      return 'blog.png'
    elsif card.is_a?(NewsStory)
      return 'news.png'
    end
  end

  def get_work_create_path(parent)
    if parent.is_a?(Artist)
      return create_news_event_blog_artist_path(parent)
    else
      return create_news_event_blog_business_path(parent)
    end
  end

  def get_link_create_path(parent)
    if parent.is_a?(Artist)
      return create_link_artist_path(parent)
    else
      return create_link_business_path(parent)
    end
  end

  def update_allowed?
    if @artist
      return policy(@artist).update?
    elsif @business
      return policy(@business).update?
    else
      false
    end
  end

  def artist_fan_link(artist)
    artist.artist_fans.reload
    if artist.artist_fans.collect{|af| af.user}.include?(current_user)
      return link_to '<i class="fa fa-remove" aria-hidden="true"></i> Following Artist'.html_safe, add_remove_fan_artist_path(artist),
        remote: true, data: { confirm: "Are you sure you want to stop following #{artist.profile_name}" }

    else
      return link_to '<i class="fa fa-plus" aria-hidden="true"></i> Follow Artist'.html_safe, add_remove_fan_artist_path(artist), remote: true
    end
  end

  def event_count(industry, locale)
    count = if locale == 'local' && current_user
      Industry.find_by_name(industry).events.viewable.collect do |event|
        event if event.country == ISO3166::Country.find_country_by_alpha2(current_user.country).name
      end.compact.count
    else
      Industry.find_by_name(industry).events.viewable.count
    end
  end

  def speciality_count(speciality, locale)
    count = if locale == 'local' && current_user
      ArtistSpeciality.find_by_name(speciality).artists.viewable.where(country_of_birth: current_user.country).count
    else
      ArtistSpeciality.find_by_name(speciality).artists.viewable.count
    end
  end
end
