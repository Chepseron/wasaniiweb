# == Schema Information
#
# Table name: admins
#
#  id              :integer          not null, primary key
#  name            :string
#  email           :string
#  password_digest :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  admin_role_id   :integer
#  deactivated     :boolean
#

class Admin < ApplicationRecord
  has_secure_password
  has_and_belongs_to_many :industries
  validates_presence_of :name, :email

  has_many :businesses, as: :parent
  belongs_to :admin_role

  validate :has_industry?, if: :content_administrator?

  def editor?
    admin_role.name == "Editor"
  end

  def content_administrator?
    admin_role.name == "Content Administrator"
  end

  def system_administrator?
    admin_role.name == "System Administrator"
  end

  private
    def has_industry?
      return errors.add(:industries, 'must select at least one')  if industries.empty?
    end

end
