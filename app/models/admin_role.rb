# == Schema Information
#
# Table name: admin_roles
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class AdminRole < ApplicationRecord
  has_many :admins
end
