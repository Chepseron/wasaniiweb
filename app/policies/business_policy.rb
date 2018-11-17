class BusinessPolicy < ApplicationPolicy
  def update?
    record.parent == user or record.managing_users.include?(user)
  end
end
