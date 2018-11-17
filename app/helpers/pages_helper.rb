module PagesHelper
  def card_owner(card)
    if card.parent.is_a? Business
      return card.parent.name
    else
      return card.parent.profile_name
    end
  end

  def artist_owner(artist)
    if artist.parent.is_a? Business
      return artist.parent.name
    else
      return artist.parent.name
    end
  end

  def nominee_image(nominee)
    if (nominee.is_a?(Artist) || nominee.is_a?(Business))
      artist_image(nominee)
    else
      entity_image(nominee)
    end
  end

  def entity_image(entity)
    if entity.is_a? Production
      entity.cover_picture_stored? ? entity.cover_picture.url : 'default-profile-pic.png'
    elsif entity.is_a? Book
      entity.cover_pic_stored? ? entity.cover_pic.url : 'default-profile-pic.png'
    elsif entity.is_a? CollectionAlbum
      entity.cover_pic_stored? ? entity.cover_pic.url : 'default-profile-pic.png'
    else
      entity.image_stored? ? entity.image.url : 'default-profile-pic.png'
    end
  end

  def entity_date(entity)
    if (entity.is_a?(Production) || entity.is_a?(Song))
      entity.release_date.strftime("#{entity.release_date.day.ordinalize} %B %Y") unless entity.release_date.nil?
    elsif entity.is_a? Book
      entity.publishing_date.strftime("#{entity.publishing_date.day.ordinalize} %B %Y") unless entity.publishing_date.nil?
    elsif entity.is_a? PhotoArt
      entity.date.strftime("#{entity.date.day.ordinalize} %B %Y") unless entity.date.nil?
    elsif entity.is_a? CollectionAlbum
      entity.album_date.strftime("#{entity.album_date.day.ordinalize} %B %Y") unless entity.album_date.nil?
    end
  end
end
