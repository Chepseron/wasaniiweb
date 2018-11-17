module BusinessesHelper
  def business_image(business)
    business.logo_stored? ? business.logo.url : 'default-business-pic.png'
  end

  def business_fan_link(business)
    business.business_fans.reload
    if business.business_fans.collect{|bf| bf.user}.include?(current_user)
      return link_to '<i class="fa fa-remove" aria-hidden="true"></i> Unfollow Business'.html_safe, add_remove_fan_business_path(business),
        remote: true, data: { confirm: "Are you sure you want to stop following #{business.name}" }
    else
      return link_to '<i class="fa fa-plus" aria-hidden="true"></i> Follow Business'.html_safe, add_remove_fan_business_path(business), remote: true
    end
  end

  def business_speciality_count(industry, locale)
    if locale == 'local' && current_user
      industry.businesses.viewable.where(country: current_user.country).count
    else
      industry.businesses.count
    end
  end
end
