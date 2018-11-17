module AdminHelper
  def admin_role(admin)
    if admin.content_provider? && admin.admin_role.nil?
      return 'Content Provider'
    elsif admin.content_provider? && !admin.admin_role.nil?
      admin.admin_role.name
    end
  end
end
