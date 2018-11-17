module ApplicationHelper
  def dont_render_sidebar
    controller_name == 'sessions' ||
    (controller_name == 'users' && action_name == 'new') ||
    controller_name == 'password_resets' ||
    controller_name == 'errors'
  end

  def link_to_login_with(url, html_options = {})
    add_default_class(html_options)
    convert_popup_attributes(html_options)

    link_to t('.login_with_link'), url, html_options
  end

  def get_create_entity_artist_path(parent)
    if parent.is_a? Artist
      create_entity_artist_path(parent)
    elsif parent.is_a? Business
      create_entity_business_path(parent)
    end
  end

  def title(blog_title)
    content_for(:title) { blog_title }
  end

  def meta_description(blog_text)
    blog_text = blog_text.present? ? blog_text : "Wasanii, is a project that intends to provide a platform for artists in the theater, music, film, arts and fashion industries to express themselves, share experiences and skills while nurturing raw talent"
    content_for(:meta_description) { blog_text }
  end

  private

  def add_default_class(html_options)
    default_class = "popup"

    if html_options.has_key?(:class)
      html_options[:class] << " " << default_class
    else
      html_options[:class] = default_class
    end
  end

  def convert_popup_attributes(html_options)
    width = html_options.delete(:width)
    height = html_options.delete(:height)

    if width && height
      html_options[:data] ||= {}
      html_options[:data].merge!({width: width, height: height})
    end
  end

  def show_sidebar?
    if current_page?(:root) || controller_name == 'password_resets' || controller_name == 'sessions' || current_page?(:signup)
      return false
    else
      return true
    end
  end

  def event_date(event)
    event.date == Date.today ? "Today" : event.date.strftime("#{event.date.day.ordinalize} %b %Y")
  end

  def get_ad(position_name)
    SiteAd.where(active: true).find_by_site_ad_position_id(SiteAdPosition.find_by_name(position_name).id)
  end

end
