class ArtistPolicy < ApplicationPolicy
  def update?
    record.managing_users.include?(user) or record.parent == user or
    (record.parent.is_a?(Business) and record.parent.parent == user)
  end

  def publish?
    # user.content_publisher? or user.content_admin?
  end
  def delete?
      record.parent == user
  end

  def deactivate?
      record == user
  end
end
