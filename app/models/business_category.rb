# == Schema Information
#
# Table name: business_categories
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class BusinessCategory < ApplicationRecord
  has_many :businesses

  validates :name, presence: true , uniqueness: true

  default_scope -> {order(:name)}
end
